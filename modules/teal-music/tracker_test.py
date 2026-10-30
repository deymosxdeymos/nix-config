import datetime
import importlib.util
import json
import sys
import threading
import unittest
from http.server import BaseHTTPRequestHandler, HTTPServer

spec = importlib.util.spec_from_file_location("tracker", sys.argv.pop(1))
tracker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(tracker)

TRACK = {
    "id": "track-id", "trackName": "Music with \"quotes\"\nnext line",
    "artist": "Artist", "releaseName": "Album", "duration": 200, "position": 30,
}


class Handler(BaseHTTPRequestHandler):
    requests = []
    record = None
    version = 0
    fail_auth = False

    def do_POST(self):
        cls = type(self)
        body = json.loads(self.rfile.read(int(self.headers["Content-Length"])))
        method = self.path.rsplit("/", 1)[-1]
        cls.requests.append((method, body, self.headers.get("Authorization")))
        if cls.fail_auth:
            self.send_response(401)
            self.end_headers()
            return
        if method == "com.atproto.repo.putRecord":
            cls.version += 1
            cls.record = body["record"]
            result = {"cid": f"cid-{cls.version}"}
        elif method == "com.atproto.repo.deleteRecord":
            if body["swapRecord"] != f"cid-{cls.version}":
                self.send_response(400)
                self.end_headers()
                return
            cls.record = None
            result = {}
        else:
            self.send_response(404)
            self.end_headers()
            return
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps(result).encode())

    def log_message(self, *_):
        pass


class TrackerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.server = HTTPServer(("127.0.0.1", 0), Handler)
        cls.thread = threading.Thread(target=cls.server.serve_forever)
        cls.thread.start()

    @classmethod
    def tearDownClass(cls):
        cls.server.shutdown()
        cls.thread.join()
        cls.server.server_close()

    def setUp(self):
        Handler.requests = []
        Handler.record = None
        Handler.version = 0
        Handler.fail_auth = False
        self.client = tracker.Client(
            f"http://127.0.0.1:{self.server.server_port}", "test.invalid", "test",
        )
        self.client.token = "test-access-token"
        self.client.did = "did:plc:test"
        self.now = datetime.datetime(2026, 10, 30, tzinfo=datetime.timezone.utc)

    def test_live_status_and_pause_through_http(self):
        self.client.publish(tracker.parse_track(TRACK), self.now)
        self.assertEqual(Handler.record["item"]["trackName"], TRACK["trackName"])
        self.assertEqual(Handler.record["item"]["artists"], [{"artistName": "Artist"}])
        expiry = datetime.datetime.fromisoformat(Handler.record["expiry"])
        self.assertEqual((expiry - self.now).total_seconds(), 60)
        start = datetime.datetime.fromisoformat(Handler.record["item"]["playedTime"])
        self.assertEqual((self.now - start).total_seconds(), 30)
        self.assertEqual(Handler.requests[0][2], "Bearer test-access-token")
        self.client.clear()
        self.assertIsNone(Handler.record)
        self.client.clear()
        self.assertEqual(len(Handler.requests), 2)

    def test_pause_does_not_delete_another_publishers_status(self):
        self.client.publish(TRACK, self.now)
        Handler.version += 1
        Handler.record = {"other": "publisher"}
        with self.assertRaises(tracker.TrackerError):
            self.client.clear()
        self.assertEqual(Handler.record, {"other": "publisher"})
        self.client.clear()
        self.assertEqual(len(Handler.requests), 2)

    def test_expired_token_is_discarded_without_blind_mutation_retry(self):
        Handler.fail_auth = True
        with self.assertRaises(tracker.TrackerError):
            self.client.publish(TRACK, self.now)
        self.assertIsNone(self.client.token)
        self.assertEqual(len(Handler.requests), 1)

    def test_stopped_music_is_absence(self):
        self.assertIsNone(tracker.parse_track(None))
        self.client.clear()
        self.assertEqual(Handler.requests, [])

    def test_invalid_metadata(self):
        invalid = [[], {}, {**TRACK, "artist": ""}, {**TRACK, "trackName": None}]
        for field in ("duration", "position"):
            for value in (-1, True, float("inf"), float("nan"), "30", None):
                invalid.append({**TRACK, field: value})
        for value in invalid:
            with self.subTest(value=value), self.assertRaises(tracker.TrackerError):
                tracker.parse_track(value)

    def test_seek_and_fractional_timing(self):
        for position in (0, 0.5, 199.9, 200):
            track = tracker.parse_track({**TRACK, "position": position})
            record = tracker.status_record(track, self.now)
            start = datetime.datetime.fromisoformat(record["item"]["playedTime"])
            self.assertEqual((self.now - start).total_seconds(), position)


if __name__ == "__main__":
    unittest.main()

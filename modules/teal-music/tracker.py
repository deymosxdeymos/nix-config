import argparse
import datetime
import json
import math
import signal
import subprocess
import sys
import threading
import urllib.error
import urllib.request


class TrackerError(Exception):
    pass


def parse_track(value):
    if value is None:
        return None
    if not isinstance(value, dict):
        raise TrackerError("Music returned invalid track metadata")
    for field in ("id", "trackName", "artist", "releaseName"):
        if not isinstance(value.get(field), str):
            raise TrackerError("Music returned invalid text metadata")
    if not value["trackName"].strip() or not value["artist"].strip():
        raise TrackerError("Music returned an empty track or artist")
    for field in ("duration", "position"):
        number = value.get(field)
        if type(number) not in (int, float) or not math.isfinite(number) or number < 0:
            raise TrackerError("Music returned invalid playback timing")
    return value


def read_track(script):
    try:
        result = subprocess.run(
            ["/usr/bin/osascript", "-l", "JavaScript", script],
            capture_output=True, text=True, timeout=10, check=True,
        )
        return parse_track(json.loads(result.stdout))
    except (subprocess.SubprocessError, json.JSONDecodeError) as error:
        raise TrackerError("Cannot read Music; check its Automation permission") from error


def status_record(track, now):
    started = now - datetime.timedelta(seconds=track["position"])
    return {
        "$type": "fm.teal.actor.status",
        "time": now.isoformat(),
        "expiry": (now + datetime.timedelta(seconds=60)).isoformat(),
        "item": {
            "trackName": track["trackName"],
            "artists": [{"artistName": track["artist"]}],
            "releaseName": track["releaseName"],
            "duration": round(track["duration"]),
            "playedTime": started.isoformat(),
            "musicServiceUri": "https://music.apple.com",
            "submissionClientAgent": "dev.deymos.teal-music/1.0",
        },
    }


class Client:
    def __init__(self, pds, actor, service):
        self.pds = pds
        self.actor = actor
        self.service = service
        self.token = None
        self.did = None
        self.cid = None

    def request(self, method, body, authenticated=True):
        headers = {"Content-Type": "application/json"}
        if authenticated:
            if self.token is None:
                self.login()
            headers["Authorization"] = f"Bearer {self.token}"
        request = urllib.request.Request(
            f"{self.pds}/xrpc/{method}",
            data=json.dumps(body).encode(), headers=headers, method="POST",
        )
        try:
            with urllib.request.urlopen(request, timeout=10) as response:
                raw = response.read()
            return json.loads(raw) if raw else {}
        except urllib.error.HTTPError as error:
            status = error.code
            try:
                failure = json.loads(error.read(4096))
            except (OSError, ValueError):
                failure = None
            finally:
                error.close()
            code = failure.get("error") if isinstance(failure, dict) else None
            if status == 401 or (status == 400 and code in ("ExpiredToken", "InvalidToken")):
                self.token = None
            detail = f"HTTP {status}"
            if code in ("ExpiredToken", "InvalidToken", "InvalidRequest", "InvalidSwap", "AuthRequired", "InsufficientScope"):
                detail += f", {code}"
            raise TrackerError(f"AT Protocol request failed: {method} ({detail})") from None
        except (OSError, ValueError) as error:
            raise TrackerError(f"AT Protocol request failed: {method}") from error

    def login(self):
        try:
            result = subprocess.run(
                ["/usr/bin/security", "find-generic-password", "-a", self.actor,
                 "-s", self.service, "-w"],
                capture_output=True, text=True, check=True, timeout=15,
            )
        except subprocess.SubprocessError as error:
            raise TrackerError("Cannot read the Teal app password from login Keychain") from error
        session = self.request("com.atproto.server.createSession", {
            "identifier": self.actor, "password": result.stdout.rstrip("\n"),
        }, authenticated=False)
        if not isinstance(session, dict) or not isinstance(session.get("accessJwt"), str):
            raise TrackerError("AT Protocol returned an invalid session")
        if not isinstance(session.get("did"), str) or not session["did"].startswith("did:"):
            raise TrackerError("AT Protocol returned an invalid account")
        self.token = session["accessJwt"]
        self.did = session["did"]

    def publish(self, track, now):
        if self.token is None:
            self.login()
        result = self.request("com.atproto.repo.putRecord", {
            "repo": self.did, "collection": "fm.teal.actor.status", "rkey": "self",
            "record": status_record(track, now),
        })
        if not isinstance(result, dict) or not isinstance(result.get("cid"), str):
            raise TrackerError("AT Protocol returned an invalid status receipt")
        self.cid = result["cid"]

    def clear(self):
        if self.cid is None:
            return
        cid = self.cid
        self.cid = None
        self.request("com.atproto.repo.deleteRecord", {
            "repo": self.did, "collection": "fm.teal.actor.status", "rkey": "self",
            "swapRecord": cid,
        })


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--pds")
    parser.add_argument("--actor")
    parser.add_argument("--keychain-service")
    parser.add_argument("--music-script", required=True)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.check:
        print(json.dumps(read_track(args.music_script)))
        return
    if not args.pds or not args.pds.startswith("https://"):
        parser.error("--pds must use HTTPS")
    if not args.actor or not args.keychain_service:
        parser.error("--actor and --keychain-service are required for publishing")
    client = Client(args.pds.rstrip("/"), args.actor, args.keychain_service)
    stopped = threading.Event()
    for signum in (signal.SIGTERM, signal.SIGINT):
        signal.signal(signum, lambda *_: stopped.set())
    try:
        while not stopped.is_set():
            delay = 20
            try:
                track = read_track(args.music_script)
                if track is None:
                    client.clear()
                else:
                    client.publish(track, datetime.datetime.now(datetime.timezone.utc))
            except TrackerError as error:
                print(str(error), file=sys.stderr, flush=True)
                delay = 60
            stopped.wait(delay)
    finally:
        try:
            client.clear()
        except TrackerError as error:
            print(str(error), file=sys.stderr, flush=True)


if __name__ == "__main__":
    main()

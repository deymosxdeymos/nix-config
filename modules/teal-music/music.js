const music = Application("com.apple.Music");
if (!music.running() || music.playerState() !== "playing") {
  JSON.stringify(null);
} else {
  const track = music.currentTrack;
  JSON.stringify({
    id: track.persistentID(),
    trackName: track.name(),
    artist: track.artist(),
    releaseName: track.album(),
    duration: track.duration(),
    position: music.playerPosition(),
  });
}

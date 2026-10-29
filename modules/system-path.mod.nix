{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.system-path;
  flake.darwinModules.system-path =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.attrsets) genAttrs' nameValuePair;
      inherit (lib.lists) singleton;
      inherit (lib.modules) mkForce;
      inherit (lib.strings) makeBinPath;
      inherit (lib.trivial) flip;
    in
    {
      environment.profiles = mkForce [
        "/etc/profiles/per-user/$USER"
        "/run/current-system/sw"
        "/nix/var/nix/profiles/default"
      ];

      environment.systemPath = mkForce <| singleton <| makeBinPath config.environment.profiles;

      environment.systemPackages = [
        pkgs.gnugrep

        (pkgs.linkFarm "darwin-tools" (
          flip genAttrs' (name: nameValuePair "bin/${name}" "/bin/${name}") [
            "launchctl"
            "ps"
          ]
          // flip genAttrs' (name: nameValuePair "bin/${name}" "/usr/bin/${name}") [
            "arch"
            "c++"
            "caffeinate"
            "cc"
            "clang"
            "clang++"
            "codesign"
            "defaults"
            "ditto"
            "file"
            "hdiutil"
            "killall"
            "ld"
            "log"
            "make"
            "man"
            "mdfind"
            "open"
            "osascript"
            "pbcopy"
            "pbpaste"
            "pgrep"
            "pkill"
            "plutil"
            "pmset"
            "security"
            "sudo"
            "sw_vers"
            "swift"
            "tmutil"
            "top"
            "tput"
            "unzip"
            "which"
            "xattr"
            "xcode-select"
            "xcodebuild"
            "xcrun"
            "zip"
          ]
          // flip genAttrs' (name: nameValuePair "bin/${name}" "/sbin/${name}") [
            "ifconfig"
            "ping"
          ]
          // flip genAttrs' (name: nameValuePair "bin/${name}" "/usr/sbin/${name}") [
            "diskutil"
            "lsof"
            "networksetup"
            "scutil"
            "softwareupdate"
            "sysctl"
            "system_profiler"
          ]
        ))
      ];
    };
}

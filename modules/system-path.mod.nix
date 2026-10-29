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
            "afplay"
            "arch"
            "bc"
            "bzip2"
            "c++"
            "caffeinate"
            "cc"
            "clang"
            "clang++"
            "clear"
            "codesign"
            "column"
            "dc"
            "defaults"
            "dig"
            "ditto"
            "file"
            "hdiutil"
            "hexdump"
            "host"
            "iconv"
            "install_name_tool"
            "killall"
            "ld"
            "lipo"
            "locale"
            "log"
            "make"
            "man"
            "mdfind"
            "mdls"
            "nc"
            "nm"
            "nslookup"
            "open"
            "osascript"
            "otool"
            "patch"
            "pbcopy"
            "pbpaste"
            "pgrep"
            "pkill"
            "plutil"
            "pmset"
            "reset"
            "rsync"
            "say"
            "security"
            "shasum"
            "sips"
            "strings"
            "sudo"
            "sw_vers"
            "swift"
            "tmutil"
            "top"
            "tput"
            "unzip"
            "w"
            "which"
            "xattr"
            "xcode-select"
            "xcodebuild"
            "xcrun"
            "xxd"
            "zip"
          ]
          // flip genAttrs' (name: nameValuePair "bin/${name}" "/sbin/${name}") [
            "ifconfig"
            "md5"
            "mount"
            "ping"
            "route"
            "umount"
          ]
          // flip genAttrs' (name: nameValuePair "bin/${name}" "/usr/sbin/${name}") [
            "arp"
            "diskutil"
            "lsof"
            "netstat"
            "networksetup"
            "screencapture"
            "scutil"
            "softwareupdate"
            "sysctl"
            "system_profiler"
            "traceroute"
          ]
        ))
      ];
    };
}

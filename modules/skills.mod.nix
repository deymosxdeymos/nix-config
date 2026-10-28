{ self, ... }:
{
  flake.homeModules.default = self.homeModules.skills;
  flake.homeModules.skills =
    { config, lib, ... }:
    let
      inherit (lib.attrsets) genAttrs' nameValuePair;
    in
    {
      files =
        genAttrs'
          [
            "babysit-pr"
            "full-send"
            "full-stop"
            "jj-stack"
            "sol-loop"
          ]
          (
            name:
            nameValuePair ".agents/skills/${name}" {
              source = "${config.directory}/Developer/skills/${name}";
            }
          );
    };
}

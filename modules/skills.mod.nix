{ self, ... }:
{
  flake.homeModules.default = self.homeModules.skills;
  flake.homeModules.skills =
    { config, lib, ... }:
    let
      inherit (lib.attrsets) genAttrs' nameValuePair;
    in
    {
      # Agent skills live in the private ~/Developer/skills repo. They are linked
      # out of the store so edits apply without a rebuild. Only these names are
      # managed; the rest of ~/.agents/skills belongs to skill installers.
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

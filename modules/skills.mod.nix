{ self, inputs, ... }:
{
  flake.homeModules.default = self.homeModules.skills;
  flake.homeModules.skills =
    { config, lib, ... }:
    let
      inherit (lib.attrsets) filterAttrs mapAttrs' nameValuePair;
      inherit (lib.filesystem) readDir;
    in
    {
      files =
        (
          readDir "${inputs.tstack}/skills"
          |> filterAttrs (_: type: type == "directory")
          |> mapAttrs' (
            name: _:
            nameValuePair ".agents/skills/${name}" {
              source = "${inputs.tstack}/skills/${name}";
            }
          )
        )
        // {
          ".agents/skills/jj-stack".source = "${config.directory}/Developer/skills/jj-stack";
          ".agents/skills/gamgen-boat".source = "${config.directory}/Developer/skills/gamgen-boat";
          ".agents/skills/council".source = "${config.directory}/Developer/skills/council";
        };
    };
}

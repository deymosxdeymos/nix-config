{ self }:
let
  inherit (self) attrNames isAttrs;
  inherit (self.attrsets) mapAttrsToList;
  inherit (self.strings)
    concatLines
    concatStringsSep
    replaceStrings
    stringLength
    ;
  inherit (self.lists)
    flatten
    singleton
    sortOn
    toList
    ;
in
{
  generators.toSSHConfig =
    attrs:
    let
      render =
        value:
        if value == true then
          "yes"
        else if value == false then
          "no"
        else
          toString value;

      toLines =
        {
          indent ? "",
        }:
        attrs:
        attrs
        |> mapAttrsToList (name: value: toList value |> map (value: "${indent}${name} ${render value}"))
        |> flatten;
    in
    attrs
    |> attrNames
    |> sortOn (name: if !isAttrs attrs.${name} then -67 else 0)
    |> map (
      name:
      let
        value = attrs.${name};
      in
      if !isAttrs value then
        toLines { } { ${name} = value; }
      else
        value
        |> attrNames
        |> sortOn (pattern: -(stringLength <| replaceStrings [ "*" "?" ] [ "" "" ] pattern))
        |> map (pattern: singleton "${name} ${pattern}" ++ toLines { indent = "\t"; } value.${pattern})
        |> flatten
    )
    |> flatten
    |> concatLines;

  generators.toLesskey =
    sections:
    sections
    |> mapAttrsToList (
      section: entries:
      let
        separator = if section == "env" then " = " else " ";
      in
      singleton "#${section}"
      ++ mapAttrsToList (
        name: value: name + separator + (toList value |> map (value: "${value}") |> concatStringsSep " ")
      ) entries
    )
    |> flatten
    |> concatLines;
}

{
  config,
  lib,
  wlib,
  inputs,
  options,
  ...
}:
{
  imports = [ wlib.wrapperModules.neovim ];

  options.nvim-lib.pluginsFromPrefix = lib.mkOption {
    readOnly = true;
    type = lib.types.raw;
    default =
      prefix: ins:
      lib.pipe ins [
        builtins.attrNames
        (builtins.filter (s: lib.hasPrefix prefix s))
        (map (
          input:
          let
            name = lib.removePrefix prefix input;
          in
          {
            inherit name;
            value = config.nvim-lib.mkPlugin name ins.${input};
          }
        ))
        builtins.listToAttrs
      ];
  };

  options.nvim-lib.neovimPlugins = lib.mkOption {
    readOnly = true;
    type = lib.types.attrsOf wlib.types.stringable;
    default = config.nvim-lib.pluginsFromPrefix "plugins-" inputs;
  };

  config.specMods =
    { ... }:
    {
      options.runtimePkgs = options.runtimePkgs // {
        description = ''
          A runtimePkgs spec field to put packages on the PATH.
          If the spec is disabled, this value is not included in the resulting neovim derivation.
        '';
      };
    };
  config.runtimePkgs = config.specCollect (acc: v: acc ++ (v.runtimePkgs or [ ])) [ ];

  config.settings.config_directory = ../.;
}

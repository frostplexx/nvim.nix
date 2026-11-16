{
  config,
  lib,
  wlib,
  inputs,
  options,
  pkgs,
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
        (builtins.filter (s: lib.hasPrefix prefix s && (ins.${s}._type or null) != "flake"))
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
  config.runtimePkgs =
    [
      pkgs.man
      pkgs.secretspec
    ]
    ++ config.specCollect (acc: v: acc ++ (v.runtimePkgs or [ ])) [ ];

  # The API key is resolved lazily from lua (plugins/minuet.lua), which finds
  # secretspec.toml on the runtimepath.

  config.settings.aliases = [
    "vi"
    "vim"
  ];

  config.settings.config_directory = ../.;
}

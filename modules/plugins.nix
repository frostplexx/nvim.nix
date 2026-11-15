{ config, lib, inputs, pkgs, ... }:
let
  pluginNames = lib.pipe inputs [
    builtins.attrNames
    (builtins.filter (name: lib.hasPrefix "plugins-" name))
    (map (name: lib.removePrefix "plugins-" name))
  ];

  pluginDir = ../plugins;
  pluginFiles = builtins.readDir pluginDir;

  luaFor =
    name:
    let
      file = "${name}.lua";
    in
    if (pluginFiles.${file} or null) == "regular" then
      builtins.readFile (pluginDir + "/${file}")
    else
      null;

  specOverrides = {
    lzn.lazy = false;
    plenary.lazy = false;
    telescope.runtimePkgs = [
      pkgs.ripgrep
      pkgs.fd
    ];
  };

  registrationFor =
    name: lua: ''
      do
        local pname = ${builtins.toJSON name}
        local spec = (function(pname)
      ${lua}
        end)(pname)
        spec[1] = pname
        require("lz.n").load(spec)
      end
    '';

  registrations = lib.concatStringsSep "\n" (
    lib.mapAttrsToList registrationFor (
      lib.filterAttrs (_: lua: lua != null) (lib.genAttrs pluginNames luaFor)
    )
  );

  mkSpec =
    name:
    {
      data = config.nvim-lib.neovimPlugins.${name};
      lazy = true;
    }
    // (specOverrides.${name} or { });
in
{
  config.specs = lib.genAttrs pluginNames mkSpec // {
    lz-n-load = {
      data = null;
      config = registrations;
    };
  };
}

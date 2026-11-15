{ config, lib, inputs, pkgs, ... }:
let
  pluginDir = ../plugins;
  pluginFiles = builtins.readDir pluginDir;

  inputPluginNames = lib.pipe inputs [
    builtins.attrNames
    (builtins.filter (name: lib.hasPrefix "plugins-" name && (inputs.${name}._type or null) != "flake"))
    (map (name: lib.removePrefix "plugins-" name))
  ];

  luaPluginNames = lib.pipe pluginFiles [
    builtins.attrNames
    (builtins.filter (file: lib.hasSuffix ".lua" file))
    (map (file: lib.removeSuffix ".lua" file))
  ];

  pluginNames = lib.unique (inputPluginNames ++ luaPluginNames);

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
    "friendly-snippets".lazy = false;
    treesitter = {
      pname = "treesitter";
      data = pkgs.vimPlugins.nvim-treesitter.withPlugins (
        plugins: with plugins; [
          bash
          c
          cpp
          css
          fish
          go
          html
          javascript
          json
          just
          lua
          markdown
          markdown_inline
          nix
          python
          query
          rust
          toml
          tsx
          typescript
          vim
          vimdoc
          yaml
        ]
      );
    };
    "blink-cmp" = {
      pname = "blink-cmp";
      data = pkgs.vimPlugins.blink-cmp;
    };
  };

  # Restricted parser: only a top-level `runtimePackages = { "a", "b" }`
  # with no nested tables or braces in the list.
  parseRuntimePackages =
    content:
    let
      flat = lib.replaceStrings [ "\n" "\r" ] [ " " " " ] content;
      match = builtins.match ".*runtimePackages[[:space:]]*=[[:space:]]*\\{([^}]*)\\}.*" flat;
      tokens =
        if match == null then
          [ ]
        else
          lib.filter (token: builtins.isString token && token != "") (
            builtins.split "[,\"[:space:]]+" (builtins.head match)
          );
    in
    map (name: lib.getAttrFromPath (lib.splitString "." name) pkgs) tokens;

  registrationFor =
    name: lua: /* lua */ ''
      do
        local pname = ${builtins.toJSON name}
        local spec = (function(pname)
      ${lua}
        end)(pname)
        spec[1] = pname
        spec.runtimePackages = nil
        local user_after = spec.after
        local setup = spec.setup
        spec.setup = nil
        spec.after = function()
          if setup ~= false then
            local modname = type(setup) == "string" and setup or pname
            local ok, mod = pcall(require, modname)
            if ok and type(mod) == "table" and type(mod.setup) == "function" then
              mod.setup {}
            end
          end
          if user_after then user_after() end
        end
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
    let
      override = specOverrides.${name} or { };
      lua = luaFor name;
      runtimePkgs = if lua == null then [ ] else parseRuntimePackages lua;
    in
    {
      data = override.data or config.nvim-lib.neovimPlugins.${name};
      lazy = true;
    }
    // lib.optionalAttrs (runtimePkgs != [ ]) { inherit runtimePkgs; }
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

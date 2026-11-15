{
  description = "Flake exporting a configured neovim package";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    wrappers.url = "github:nix-community/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    plugins-lzn = {
      url = "github:lumen-oss/lz.n";
      flake = false;
    };
    plugins-plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    plugins-catppuccin = {
      url = "github:catppuccin/nvim";
      flake = false;
    };
    plugins-yazi = {
      url = "github:mikavilpas/yazi.nvim";
      flake = false;
    };
    plugins-fzf-lua = {
      url = "github:ibhagwan/fzf-lua";
      flake = false;
    };
    plugins-mini = {
      url = "github:echasnovski/mini.nvim";
      flake = false;
    };
    plugins-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    plugins-friendly-snippets = {
      url = "github:rafamadriz/friendly-snippets";
      flake = false;
    };
    plugins-conform = {
      url = "github:stevearc/conform.nvim";
      flake = false;
    };
    plugins-ts-error-translator = {
      url = "github:dmmulroy/ts-error-translator.nvim";
      flake = false;
    };
    plugins-render-markdown = {
      url = "github:MeanderingProgrammer/render-markdown.nvim";
      flake = false;
    };
    plugins-nvim-lint = {
      url = "github:mfussenegger/nvim-lint";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      wrappers,
      ...
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
      module = {
        imports = [
          ./modules/wrapper.nix
          ./modules/plugins.nix
        ];
      };
      wrapper = wrappers.lib.evalModules {
        specialArgs = { inherit inputs; };
        modules = [ module ];
      };
    in
    # for demonstration purposes, we will set up all the outputs.
    {
      wrapperModules = {
        neovim = module;
        default = self.wrapperModules.neovim;
      };
      wrappers = {
        neovim = wrapper.config;
        default = self.wrappers.neovim;
      };
      overlays = {
        neovim = final: prev: {
          neovim = self.wrappers.neovim.wrap {
            pkgs = prev.extend inputs.neovim-nightly-overlay.overlays.default;
          };
        };
        default = self.overlays.neovim;
      };
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ inputs.neovim-nightly-overlay.overlays.default ];
          };
        in
        {
          neovim = self.wrappers.neovim.wrap { inherit pkgs; };
          default = self.packages.${system}.neovim;
        }
      );
      # home manager and nixos modules
      # `wrappers.neovim.enable = true`
      # You can set any of the options.
      # But that is how you enable it.
      nixosModules = {
        default = self.nixosModules.neovim;
        neovim = wrappers.lib.getInstallModule {
          name = "neovim";
          value = module;
          specialArgs = { inherit inputs; };
        };
      };
      homeModules = {
        default = self.homeModules.neovim;
        # they produce generically importable modules
        neovim = self.nixosModules.neovim;
      };
    };
}

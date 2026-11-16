Experimental portable NeoVim config written in nix and lua

## Secrets

`CODESTRAL_API_KEY` (minuet) is declared in `secretspec.toml` and resolved from the OS keyring when neovim starts. Store it once per machine:

```sh
secretspec set CODESTRAL_API_KEY
```

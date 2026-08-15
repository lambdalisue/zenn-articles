# Zenn Contents

* [📘 How to use](https://zenn.dev/zenn/articles/zenn-cli-guide)
* [📘 Markdown guide](https://zenn.dev/zenn/articles/markdown-guide)

## Development

The toolchain (Node.js / just) comes from the Nix flake in this repository.

```console
$ cp .envrc.sample .envrc && direnv allow   # or: nix develop
$ just preview                              # http://localhost:8000
```

Run `just` to see the other recipes.

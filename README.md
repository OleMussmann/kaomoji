# Kaomoji Generator

This is a nix flake of the [kaomoji generator](https://charm.sh/blog/kamoji-generator/), taken from the [charmbracelet repo](https://github.com/charmbracelet/gum/blob/main/examples/kaomoji.sh).

## API Key Needed!
[mods](https://github.com/charmbracelet/mods) is the engine that fetches query
results from the OpenAI API. You need an account an [account](https://platform.openai.com/signup?launch)
at [openai.com](https://openai.com) as well as an API key.

Excerpt from charmbracelet's [README.md](https://github.com/charmbracelet/mods/blob/main/README.md):

> Mods uses GPT-4 by default and will fallback to GPT-3.5 Turbo if it's not
available. Set the `OPENAI_API_KEY` environment variable to a valid OpenAI key,
which you can get [from here](https://platform.openai.com/account/api-keys).

## Run Without Installing

```
nix run github:OleMussmann/kaomoji "bear"
```

## Declarative Installation
> :warning: The way of installing third-party flakes is highly dependent on
your personal configuration. As far as I know there is no standardized,
canonical way to do this. Instead, here is a generic approach via overlays.
You will need to adapt it to your config files.

Add `kaomoji` to your inputs:

    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

      kaomoji.url = "github:OleMussmann/kaomoji";
      kaomoji.inputs.nixpkgs.follows = "nixpkgs";
    };

Add an overlay to your outputs:

    outputs = { self, nixpkgs, ... }@inputs:
    let
      out-of-tree = final: prev: {
        kaomoji = inputs.kaomoji.packages.${prev.system}.kaomoji;
        <other third party flakes you have>
      };
    in {
      nixosConfigurations."<hostname>" = nixpkgs.lib.nixosSystem {
        ...
      };
    };

Finally, add `kaomoji` to your `systemPackages`:

      environment.systemPackages = with pkgs; [
          git
          out-of-tree.kaomoji
          ...
      ];

### 

{
  description = "Kaomoji Generator";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.mods.url = "github:OleMussmann/mods";

  outputs = { self, nixpkgs, flake-utils, mods }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      my-name = "kaomoji";
      mods_bin = mods.packages.${system}.default;
      dependencies = with pkgs; [ mods_bin gum xclip ];
      kaomoji = (pkgs.writeScriptBin my-name (builtins.readFile ./kaomoji.sh)).overrideAttrs(old: {
        buildCommand = "${old.buildCommand}\n patchShebangs $out";
      });
    in rec {
      packages.default = packages.kaomoji;
      packages.kaomoji = pkgs.symlinkJoin {
        name = my-name;
        paths = [ kaomoji ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild =
          let
            dependency_path = pkgs.lib.makeBinPath dependencies;
          in
          ''
            wrapProgram "$out/bin/${my-name}" --prefix PATH : "$out/bin:${dependency_path}"
          '';
      };
    }
  );
}

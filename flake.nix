{
  description = "LaTeX package simplifying the use of romanisations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
    let 
      pkgs = nixpkgs.legacyPackages.${system};
      outPack = pkgs.stdenvNoCC.mkDerivation rec {
        name = "lualatex-transconv";
        src = self;
        phases = [ "unpackPhase" "installPhase" ];
        buildPhase = "";
        installPhase = ''
          mkdir -p $out/tex/latex
          mkdir -p $out/kpsewhich/lua
          cp ./transconv.sty $out/tex/latex
          cp -r ./lua/transconv $out/kpsewhich/lua
        '';
      };
      # TODO
      documentation = outPack;
    in
    {
      packages = {
        package = outPack;
        doc = documentation;
        default = outPack;
      };
    });
}

{
  description = "LaTeX package simplifying the use of romanisations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixfmt.url = "github:NixOS/nixfmt";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem =
        { pkgs, system, ... }:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          pname = "transconv";
          outPack = pkgs.stdenvNoCC.mkDerivation {
            inherit pname;
            version = "1.0";
            outputs = [ "tex" ];
            src = self;
            # stop nix from complaining about missing output "out"
            nativeBuildInputs = [
              (pkgs.writeShellScript "force-tex-output.sh" ''
                out="''${tex-}"
              '')
            ];
            # buildPhase would run the makefile which is only intended
            # for people without nix
            dontBuild = true;
            installPhase = ''
              runHook preInstall

              texpath="$tex/tex/latex/${pname}"
              luapath="$tex/tex/latex/${pname}"

              mkdir -p "$texpath"
              cp *.{sty,cls,dev,clo} "$texpath"

              luapath="$tex/scripts/${pname}"
              mkdir -p "$luapath"
              cp -r lua/${pname}/* "$luapath"
              # the main file should be named like the package in this
              # location, not init
              mv "$luapath/init.lua" "$luapath/${pname}.lua"

              runHook postInstall
            '';
          };
          # TODO
          documentation = { };
        in
        {
          packages = {
            package = outPack;
            doc = documentation;
            default = outPack;
          };

          formatter = pkgs.nixfmt-tree;
        };
    };
}

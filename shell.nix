{ nixpkgs ? import <nixpkgs> {},
  compiler ? "default",
  doBenchmark ? false
}:
let
  inherit (nixpkgs) pkgs;
  f = { mkDerivation, base, stdenv }:
    mkDerivation {
      pname = "easyplot";
      version = "1.0.0.0";
      src = ./src;
      isLibrary = true;
      isExecutable = false;
      executableHaskellDepends = [ base ] ++ mydevtools;
      license = stdenv.lib.licenses.bsd3;
    };
  haskellPackages = if compiler == "default" then pkgs.haskellPackages
    else pkgs.haskell.packages.${compiler};
  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;
  drv = variant (haskellPackages.callPackage f {});

  mydevtools = [
    haskellPackages.cabal-install
    haskellPackages.ghc
    haskellPackages.ghcide
    # ghc-prof broken
    #haskellPackages.profiterole
    #haskellPackages.profiteur
  ];

in
  if pkgs.lib.inNixShell then drv.env else drv

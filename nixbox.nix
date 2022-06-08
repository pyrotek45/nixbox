{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  pname = "nixbox";
  version = "0.1.0";

  programFile = ./nixbox.sh;

  phases = [ "installPhase" "postUnpack" ];

  dontMakeSourcesWritable = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ${programFile} $out/bin/nixbox
  '';

  postUnpack = ''
    chmod +x $out/bin/nixbox 
  '';
}

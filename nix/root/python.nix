{ pkgs, ... }:
let
  almaPython = pkgs.python3.withPackages (
    ps: with ps; [
      numpy
      sympy
      versioningit
    ]
  );
in
{
  environment.systemPackages = [
    almaPython
  ];
}

{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = {self, nixpkgs, ...}:
  let 
  system = "x86_64-linux";
  pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
  in {
    devShells.${system}.default = pkgs.mkShell {

      buildInputs = [
        pkgs.gcc
        pkgs.openmpi
        pkgs.cmake
        pkgs.boost
        pkgs.fftw   #required for functionality
        pkgs.paraview #required for visualization
        pkgs.gnumake
        pkgs.bash
        pkgs.flex
        pkgs.m4
      ];
      


    };

  };


}
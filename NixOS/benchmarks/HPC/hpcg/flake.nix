{
    inputs = {
      
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

      hpcg = {
        url = "github:hpcg-benchmark/hpcg";
        flake = false;
      };
    };
    



    outputs = {self , nixpkgs , hpcg}:
      let
        system = "x86_64-linux";
        pkgs = import  nixpkgs {inherit system; config.allowUnfree = true; };
    in {
        packages.${system}.HPCG = pkgs.stdenv.mkDerivation rec {
            name = "HPCG";

            src =  hpcg;

            

                nativeBuildInputs = [ pkgs.gnumake pkgs.gcc pkgs.openmpi ];

                buildInputs = [pkgs.mkl pkgs.mkl-gnulibs ];

                configurePhase = ''

                 mkdir build && cd build

                 ../configure MPI_GCC_OMP

                '';

                buildPhase = ''

                make

                '';

                installPhase = ''

                mkdir -p $out/bin

                cp bin/xhpcg $out/bin/


                '';
            
        };
    };
}

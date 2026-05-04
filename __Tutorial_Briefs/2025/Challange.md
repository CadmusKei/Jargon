# Building and Compiling OpenBLAS and OpenMPI Libraries from Source

You now have a functioning HPL benchmark. However, using math libraries (BLAS, LAPACK, ATLAS) from a repository (`dnf`) will not yield optimal performance, because these repositories contain generic code compiled to work on all x86 hardware. If you were monitoring your compute during the execution of `xhpl`, you would have noticed that the OpenMPI and Atlas configurations restricted HPL to running with no more than two OpenMP threads.

Code compiled specifically for HPC hardware can use instruction sets like `AVX`, `AVX2` and `AVX512` (if available) to make better use of the CPU. A (much) higher HPL result is possible if you compile your math library (such as ATLAS, GOTOBLAS, OpenBLAS or Intel MKL) from source code on the hardware you intend to run the code on.

1. Install dependencies
   ```bash
   # DNF / YUM (RHEL, Rocky, Alma, Centos Stream)
   sudo dnf group install "Development Tools"
   sudo dnf install gfortran git gcc wget

   # APT (Ubuntu)
   sudo apt install build-essential hwloc libhwloc-dev libevent-dev gfortran wget

   # Pacman
   sudo dnf install base-devel gfortran git gcc wget
   ```

1. Fetch and Compile OpenBLAS Source Files
   ```bash
   # Fetch the source files from the GitHub repository
   git clone https://github.com/xianyi/OpenBLAS.git
   cd OpenBLAS

   # Tested against version 0.3.26, you can try an build `develop` branch
   git checkout v0.3.26

   # You can adjust the PREFIX to install to your preferred directory
   make
   make PREFIX=$HOME/opt/openblas install
   ```

1. Fetch, Unpack and Compile OpenMPI Source Files
   ```bash
   # Fetch and unpack the source files
   wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.4.tar.gz
   tar xf openmpi-4.1.4.tar.gz
   cd openmpi-4.1.4

   # Pay careful attention to tuning options here, and ensure they correspond
   # to your compute node's processor.
   #
   # If you are unsure, you can replace the `cascadelake` architecture option
   # with `native`, however you are expected to determine your compute node's
   # architecture using `lscpu` or similar tools.
   #
   # Once again you can adjust the --prefix to install to your preferred path.
   CFLAGS="-Ofast -march=cascadelake -mtune=cascadelake" ./configure --prefix=$HOME/opt/openmpi

   # Use the maximum number of threads to compile the application
   make -j$(nproc)
   make install
   ```

1. Compile and Configure HPL
   ```bash
   # Copy the Makefile `Make.<TEAM_NAME>` that you'd previously prepared
   # and customize it to utilize the OpenBLAS and OpenMPI libraries that
   # you have just compiled.
   cd ~/hpl
   cp Make.<TEAM_NAME> Make.compile_BLAS_MPI
   nano Make.compile_BLAS_MPI
   ```

1. Edit the platform identifier *(architecture)*, MPI and BLAS paths, and add compiler optimization flags:
   ```conf
   ARCH         = compile_BLAS_MPI

   MPdir        = $(HOME)/opt/openmpi
   MPinc        = -I$(MPdir)/include
   MPlib        = $(MPdir)/lib/libmpi.so

   LAdir        = $(HOME)/opt/openblas
   LAinc        =
   LAlib        = $(LAdir)/lib/libopenblas.a

   CC           = mpicc
   CCFLAGS      = $(HPL_DEFS) -O3 -march=cascadelake -mtune=cascadelake -fopenmp -fomit-frame-pointer -funroll-loops -W -Wall
   LDFLAGS      = -O3 -fopenmp

   LINKER       = $(CC)
   ```

1. You can now compile your new HPL:
   ```bash
   # You will also need to temporarily export the following environment
   # variables to make OpenMPI available on the system.

   export MPI_HOME=$HOME/opt/openmpi
   export PATH=$MPI_HOME/bin:$PATH
   export LD_LIBRARY_PATH=$MPI_HOME/lib:$LD_LIBRARY_PATH

   # Remember that if you make a mistake and need to recompile, first run
   # make clean arch=compile_BLAS_MPI

   make arch=compile_BLAS_MPI
   ```

1. Edit HPL to take advantage of your custom compiled MPI and Math Libraries
   Verify that a `xhpl` executable binary was in fact produced and configure your `HPL.dat` file with reference to the [Official HPL Tuning Guide](https://netlib.org/benchmark/hpl/tuning.html):
   ```bash
   cd bin/compile_BLAS_MPI

   # As a starting point when running HPL on a single node, with a single CPU
   # Try setting Ps = 1 and Qs = 1, and Ns = 21976 and NBs = 164
   nano HPL.dat
   ```

1. Finally, you can run your `xhpl` binary with custom compiled libraries.
   ```bash
   # There is no need to explicitly use `mpirun`, nor do you have to specify
   # the number of cores by exporting the `OMP_NUM_THREADS`.
   # This is because OpenBLAS is multi-threaded by default.

   ./xhpl
   ```

> [!TIP]
> Remember to open a new ssh session to your compute node and run either `top # preferably htop / btop`. Better yet, if you are running `tmux` in your current session, open a new tmux window using `C-b c` then ssh to your compute node from there, and you can cycle between the two tmux windows using `C-b n`.



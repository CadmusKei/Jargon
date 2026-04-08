# Tutorial 3: Install, Compile and Run High Performance LinPACK (HPL) Benchmark
_Sourced from: CHPC SCC Github Repo_

HPL is a crucial tool in the HPC community for benchmarking and comparing the performance of supercomputing systems. The benchmark is a software package designed to solve a dense system of linear equations using double-precision floating-point arithmetic. It is commonly used to measure the performance of supercomputers, providing a standardized way to assess their computational power.

You will now install and run HPL on your **Virtual Machine**.

1. Update the system and install dependencies

   You are going to be installing tools that will allow you to compile applications using the `make` command _(If you have completed Tut2 Part B this will be done already)._ You will also be installing a maths library to compute matrix multiplications, and an `mpi` library for communication between processes, in this case mapped to CPU cores.
   * DNF / YUM
   ```bash
   # RHEL, Rocky, Alma, Centos Steam
   sudo dnf update -y
   sudo dnf install openmpi atlas openmpi-devel atlas-devel -y
   sudo dnf install wget nano -y
   ```
   * APT
   ```bash
   # Ubuntu
   sudo apt update
   sudo apt install build-essential openmpi-bin libopenmpi-dev libatlas-base-dev
   ```
   * Pacman
   ```bash
   # Arch
   sudo pacman -Syu
   sudo pacman -S base-devel openmpi atlas-lapack nano wget
   ```
1. Fetch the HPL source files

   You will download the HPL source files. This is why you installed `wget` in the previous step.
   ```bash
   # Download the source files
   wget http://www.netlib.org/benchmark/hpl/hpl-2.3.tar.gz

   # Extract the files from the tarball
   tar -xzf hpl-2.3.tar.gz

   # Move and go into the newly extracted folder
   mv hpl-2.3 ~/hpl
   cd ~/hpl

   # list the contents of the folder
   ls
   ```
1. Configure HPL

   Copy and edit your own `Make.<YOUR_NAME>` file in the `hpl` directory to suit your system configuration.
   ```bash
   cp setup/Make.Linux_PII_CBLAS_gm Make.<YOUR_NAME>
   nano Make.<YOUR_NAME>
   ```

   You need to carefully edit your `Make.<YOUR_NAME>` file, ensuring that you make the following changes:
   * RHEL, Rocky, Alma, CentOS Stream based systems
     ```conf
     ARCH               = <YOUR_NAME>

     MPdir              = /usr/lib64/openmpi

     LAdir              = /usr/lib64/atlas
     LAlib              = $(LAdir)/libtatlas.so $(LAdir)/libsatlas.so

     CC                 = mpicc

     LINKER             = mpicc
     ```
   * Ubuntu based systems
     ```conf
     ARCH               = <TEAM_NAME>

     MPdir              = /usr/lib/x86_64-linux-gnu/openmpi

     LAdir              = /usr/lib/x86_64-linux-gnu/atlas/
     LAlib              = $(LAdir)/libblas.so $(LAdir)/liblapack.so

     CC                 = mpicc

     LINKER             = mpicc
     ```

1. Temporarily edit your `PATH` variable

   You are almost ready to compile HPL, you will need to modify your path variable in order for your MPI C Compiler `mpicc` to be a recognized binary.
   Check to see if `mpicc` is currently detected:
   ```bash
   # The following command will return a command not found error.
   which mpicc

   # Temporarily append openmpi binary path to your PATH variable
   # These settings will reset after you logout and re-login again.
   export PATH=/usr/lib64/openmpi/bin:$PATH

   # Rerun the which command to confirm that the `mpicc` binary is found
   which mpicc
   ```
1. Compile HPL

   You are finally ready to compile HPL. Should you encounter any errors and need to make adjustments and changes, first run a `make clean arch=<TEAM_NAME>`.
   ```bash
   make arch=<YOUR_NAME>

   # Confirm that your `xhpl` binary has been successfully built
   ls bin/<YOUR_NAME>
   ```

1. Configure your `HPL.dat`

   Make the following changes to your `HPL.dat` file:
   ```bash
   cd bin/<YOUR_NAME>
   nano HPL.dat
   ```

   Carefully edit you `HPL.dat` file and verify the following changes:
   ```conf
   1            # of process grids (P x Q)
   1            Ps
   1            Qs
   ```
1. Running HPL on a Single CPU

   For now, you will be running HPL on your head node, on a single CPU. Later you will learn how to run HPL over multiple CPUs, each with multiple cores, across multiple nodes...
   ```bash
   # Excute the HPL binary
   ./xhpl
   ```

> [!TIP]
> Note that when you want to configure and recompile HPL for different architectures, compilers and systems, adapt and the `Make.<NEW_CONFIG>` and recompile that architecture or configuration.
>
> If you compile fails and you would like to try to fix your errors and recompile, you must ensure that you reset to a clean start with `make clean`.

Congratulations!

You have successfully completed you first HPL benchmark.


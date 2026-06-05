# Challenge 1 — Insights

## `configure`, `make`, and `make install`

These three commands are the standard build pipeline for compiling software from source on Linux.

Think of it like this:

> `configure` = choose destination · `make` = build the package · `make install` = deliver the package

- **`configure`** reads your system and generates a `Makefile` tailored to your environment — it checks what compilers, libraries, and paths are available. This is where you tell the build system where things should go (e.g. `--prefix=/usr/local`).
- **`make`** reads the generated `Makefile` and actually compiles the source code into binaries and libraries. This is the heavy lifting step — it invokes the compiler repeatedly across all source files.
- **`make install`** copies the compiled output (binaries, libraries, headers) to the destination set during `configure`. Before this step, the software only exists in the build directory.

For HPL specifically, we skip `make install` entirely — we compile with `make arch=Jargon` and run `xhpl` directly from the `bin/Jargon/` directory.

---

## The difference between `make` and `make install`

`make` builds the software in place — the compiled files stay in the source/build directory. `make install` moves or copies those files to system-wide locations (like `/usr/local/bin` or `/usr/lib`) so that any user on the system can access them.

For a benchmark like HPL, installing system-wide is unnecessary. We build it, point to it directly, and run it. This also makes it easier to maintain multiple configurations side by side.

---

## The difference between a library and an application

- An **application** is a standalone executable that a user runs directly (e.g. `xhpl`, `mpirun`, `vim`). It has a `main()` entry point and does something on its own.
- A **library** is a collection of reusable functions that applications link against — it has no `main()` and cannot be run on its own. Libraries exist to share common functionality across multiple programs.

In our HPL stack:
- **OpenBLAS / ATLAS** are libraries — they provide optimised linear algebra routines (matrix multiply, etc.) that HPL calls internally.
- **OpenMPI** is both — it provides libraries that HPL links against (`libmpi`) and applications like `mpirun` that orchestrate parallel execution.
- **HPL (`xhpl`)** is the application — it uses both.

---

## What are `gcc`, `gfortran`, and `g++`

These are the three main compilers in the GNU Compiler Collection (GCC):

| Compiler | Language | Used for |
|----------|----------|----------|
| `gcc` | C | Most system software, MPI wrappers, HPL itself |
| `g++` | C++ | C++ applications and libraries |
| `gfortran` | Fortran | Scientific and numerical code — BLAS/LAPACK routines are often written in Fortran |

For HPL, `gcc` is the primary compiler. `gfortran` becomes relevant when building OpenBLAS from source, since parts of the BLAS reference implementation are in Fortran. In the Makefile, `CC= mpicc` is used — `mpicc` is a wrapper around `gcc` that automatically links MPI libraries.

---

## What is `$PATH`

`$PATH` is an environment variable that tells the shell where to look for executables when you type a command. It is a colon-separated list of directories searched in order.

```bash
echo $PATH
# /usr/local/bin:/usr/bin:/usr/lib64/openmpi/bin:...
```

When you type `mpirun`, the shell searches each directory in `$PATH` left to right until it finds a binary called `mpirun`. If it's not in any of those directories, you get `command not found`.

For HPL on Rocky Linux, OpenMPI installs its binaries to `/usr/lib64/openmpi/bin`, which is not in `$PATH` by default. This is why we need:

```bash
export PATH=/usr/lib64/openmpi/bin:$PATH
```

Without this, `mpicc` and `mpirun` are invisible to the shell even though they are installed. To make this permanent across sessions:

```bash
echo "export PATH=/usr/lib64/openmpi/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
```

---

## Does OpenBLAS work without OpenMPI?

Yes — OpenBLAS and OpenMPI are independent of each other.

- **OpenBLAS** handles mathematical computation — it optimises linear algebra operations (like dense matrix multiply) using CPU-level instructions (SIMD, multi-threading via OpenMP).
- **OpenMPI** handles communication — it coordinates work across multiple processes and nodes over the network.

For a single-node HPL run, OpenMPI is still used to launch processes (`mpirun -np 1 ./xhpl`), but all the actual computation is done by OpenBLAS. You could run HPL with just OpenBLAS and no inter-node communication — it would work, just limited to one machine.

In a multi-node cluster context (like CHPC), both are essential: OpenBLAS for performance, OpenMPI for parallelism across nodes.

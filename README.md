# For Polymtl-bee

This section describes how to build call_py_fort on windows.

## Compile call_py_fort on Windows

First, install Intel Fortran and C++ compilers (https://www.intel.com/content/www/us/en/developer/tools/oneapi/hpc-toolkit-download.html).

To build this library, the dependencies listed in the [Installation](##Installation) section except for pFUnit must be installed. pFUnit is a unit testing framework for Fortran (https://github.com/Goddard-Fortran-Ecosystem/pFUnit). In an ideal world, one should run the tests that are included in call_py_fort (that relies on pFUnit) to verify that everything went according to plan but to do so pFunit must be installed on the system. To build and install pFUnit on Windows is not a walk in the park and it is not the purpose of this documentation, so we will just toss it aside.

The build system Ninja is also required for the build.

In summary, these are the dependecies required to build and run call_py_fort on Windows:

    1. python (3+) with numpy and cffi
    2. cmake (>=3.4+)
    3. Intel Fortran and C++ compilers (https://www.intel.com/content/www/us/en/developer/tools/oneapi/hpc-toolkit-download.html)
    4. Ninja (https://ninja-build.org/)

Take notes that if Visual Studio Community is installed on your system cmake and Ninja might be already installed. You can install those dependecies (except for the Intel compilers) with the package manager chocolatey (https://community.chocolatey.org/) or by hand.

Once everything is installed, open the Intel OneAPI command prompt and go to the call_py_fort directory (you mmight need to open the command prompt with admistrative privilege to complete the compilation). You can compile call_py_fort using 
    
    mkdir build
    cd build 
    cmake -G Ninja ..
    ninja

All the compiled files are located in

    call_py_fort/build/src/

# call_py_fort

![status](https://github.com/VulcanClimateModeling/call_py_fort/workflows/Check/badge.svg)

Call python from Fortran (not the other way around). Inspired by this [blog
post](https://www.noahbrenowitz.com/post/calling-fortran-from-python/).

## Installation

This library has the following dependencies
1. pfUnit for the unit tests
1. python (3+) with numpy and cffi
1. cmake (>=3.4+)

This development environment can be setup with the nix package manager. To
enter a developer environment with all these dependencies installed run:

    nix-shell

Once the dependencies are installed, you can compile this library using

    mkdir build
    cd build 
    cmake ..
    make

Run the tests:

    make test

Install on your system

    make install

This will usually install the `libcallpy` library to `/usr/local/lib` and the
necessary module files to `/usr/local/include`. The specific way to add this
library to a Fortran code base will depend on the build system of that code.
Typically, you will need to add a flag `-I/usr/local/include` to any fortran
compiler commands letting the compiler find the `.mod` file for this library,
and a `-L/usr/local/lib -lcallpy` to link against the dynamic library. On
some systems, you may need to set
`LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH` at runtime to help the
dynamic linker find the library.

## Usage

Once installed, this library is very simple to use. For example:
```
program example
use callpy_mod
implicit none

real(8) :: a(10)
a = 1.0
call set_state("a", a)
call call_function("builtins", "print")
! read any changes from "a" back into a.
call get_state("a", a)

end program example
```

It basically operates by pushing fortran arrays into a global python
dictionary, calling python functions with this dictionary as input, and then
reading numpy arrays from this dictionary back into fortran. Let this
dictionary by called STATE. In terms of python operations, the above lines
roughly translate to

    # abuse of notation signifyling that the left-hand side is a numpy array
    STATE["a"] = a[:]
    # same as `print` but with module name
    builtins.print(STATE)
    # transfer from python back to fortran memory
    a[:] = STATE["a"]

You should be able to compile the above by running

    gfortran -I/usr/local/include -Wl,-rpath=/usr/local/lib -L/usr/local/lib main.f90 -lcallpy
    
Here's what happens when you run the compiled binary:
```
$ ./a.out 
{'a': array([1., 1., 1., 1., 1., 1., 1., 1., 1., 1.])}
```


By modifying, the arguments of `call_function` you can call any python
function in the pythonpath.

Currently, `get_state` and `set_state` support 4 byte or 8 byte floating
point of one, two, or three dimensions.

## Examples

See the [unit tests](/test/test_call_py_fort.pfunit) for more examples.

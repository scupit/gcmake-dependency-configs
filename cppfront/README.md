# cppfront Compatibility

[cppfront](https://github.com/hsutter/cppfront) is Herb Sutter's "experimental compiler from a
potential C++ 'syntax 2' to current modern C++ 'syntax 1'". It's in the very early stages of
experimental development.
Check out the ["Can C++ be 10x Simpler and Safer?"](https://www.youtube.com/watch?v=ELeZAKCN4tY) CppCon 2022
talk on Youtube for an idea of what cppfront is all about.

## Quick Links

- [cppfront repository](https://github.com/hsutter/cppfront)
- ["Can C++ be 10x Simpler and Safer?" talk](https://www.youtube.com/watch?v=ELeZAKCN4tY) (Contains plenty of live cppfront demos)
- [My cppfront wrapper repository](https://github.com/scupit/cppfront-cmake-wrapper)

## IMPORTANT NOTE

As of commit [8dd89ec8c9cfe9633286b2768ad0404455e342c7](https://github.com/hsutter/cppfront/commit/8dd89ec8c9cfe9633286b2768ad0404455e342c7),
the latest MinGW ld.exe (GNU binutils 2.40) distributed by msys2 fails to link cppfront.exe when
compiling with optimizations off (Debug mode). If you're building in Debug mode with MinGW g++,
you must use the `-fuse-ld=lld` flag to use LLVM's lld linker in place of ld (need to install Clang first).

**You must set the CMake options `-DGCMAKE_ADDITIONAL_COMPILER_FLAGS='fuse-ld=lld'` and `-DGCMAKE_ADDITIONAL_LINK_TIME_FLAGS='-fuse-ld=lld'`.**

## Why use a wrapper repository

The [cppfront-cmake-wrapper](https://github.com/scupit/cppfront-cmake-wrapper)
allows me to decouple the cppfront build from the GCMake tool itself. That way I can just modify the
build in the wrapper repository without needing to update any GCMake dependency configuration scripts.

The wrapper repository is also a way to just build and install cppfront using CMake, which is nice.

## Installing CppFront on your system

> **NOTE:** Using an existing installation of CppFront is *required when using Emscripten* and recommended
> when cross-compiling in general.

With any major C++20 supporting compiler:

``` sh
git clone 'git@github.com:scupit/cppfront-cmake-wrapper.git'
cd cppfront-cmake-wrapper
cmake -B build/ # ... any other CMake options such as -G 'Ninja'
cmake --build build/ --parallel
sudo cmake --install build/ # Or run in an Administrator prompt in Windows
```

[Full build details](https://github.com/scupit/cppfront-cmake-wrapper) can be found in the
[cppfront-cmake-wrapper repository README](https://github.com/scupit/cppfront-cmake-wrapper).

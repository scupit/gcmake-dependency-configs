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

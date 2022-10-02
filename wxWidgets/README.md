# wxWidgets

## Quick Links

- [wxWidgets Website](https://www.wxwidgets.org/)
- [GitHub Repository](https://github.com/wxWidgets/wxWidgets)

## Building with CMake

I use ninja with the MSYS2 MinGW GCC 12.2.0 distribution. Your compiler and build tool may vary.

``` sh
git clone --recurse-submodules git@github.com:wxWidgets/wxWidgets.git
cd wxWidgets
cmake -B build-mingw-gcc -G 'Ninja' -DCMAKE_BUILD_TYPE=Relase
cmake --build build-mingw-gcc
# This needs to be run with administrator privileges
cmake --install build-mingw-gcc
```

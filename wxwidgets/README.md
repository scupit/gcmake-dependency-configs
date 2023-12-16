# wxWidgets

## Quick Links

- [wxWidgets Website](https://www.wxwidgets.org/)
- [GitHub Repository](https://github.com/wxWidgets/wxWidgets)

## Windows Caveats

When building a CMake project on Windows which requires wxWidgets, you must provide
a `wxWidgets_LIB_DIR`. This is the actual directory where the wxWidgets libraries
reside.

For example, if your `wxWidgets_ROOT_DIR` (this is automatically set) is
`C:\Program Files (x86)\wxWidgets\`, then your `wxWidgets_LIB_DIR`
could be `C:\Program Files (x86)\wxWidgets\lib\gcc_x64_dll` if you are trying to use the
Shared MinGW build.

``` ps1
# Example
cmake -B build -DwxWidgets_LIB_DIR='C:\Program Files (x86)\wxWidgets\lib\gcc_x64_dll'
```

## Building with CMake

I use ninja with the MSYS2 MinGW GCC 12.2.0 distribution. Your compiler and build tool may vary.

``` sh
git clone --recurse-submodules git@github.com:wxWidgets/wxWidgets.git
cd wxWidgets
cmake -B build-mingw-gcc -G 'Ninja' -DCMAKE_BUILD_TYPE=Release
cmake --build build-mingw-gcc
# This needs to be run with administrator privileges
cmake --install build-mingw-gcc
```

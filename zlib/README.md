# ZLIB

A fantastic widely-used compression library.

## Quick Links

- [ZLIB Website](https://zlib.net/)
- [GitHub Repository](https://github.com/madler/zlib)
- [GitHub Releases Page](https://github.com/madler/zlib/releases)
- [ZLIB Releases source code archive](https://zlib.net/fossils/)

## Installation Options

On Debian-based Linux distriubutions, ZLIB can be retrieved with `apt install zlib1g zlib1g-dev`.

Otherwise, it's recommended to [build CURL from source using CMake](#building-with-cmake).

### ZLIB Deb Install

`apt install zlib1g zlib1g-dev`

### Building with CMake

I use Ninja with the MSYS2 MinGW GCC 12.2.0 distribution. Your compiler and build tool may vary.

``` sh
# Clone the repository, OR download and unpack a release from the source code archive.
git clone --branch 'v1.2.13' git@github.com:madler/zlib.git
cd zlib
cmake -B build-mingw -G 'Ninja' -DCMAKE_BUILD_TYPE=Release
# Example build using 10 jobs
cmake --build build-mingw -j10

# Make sure to run the 'install' with administrator privileges. The default install directory will
# require administrator privileges.
cmake --install build-mingw-gcc
```

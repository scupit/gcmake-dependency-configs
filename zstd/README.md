# ZSTD

Fast lossless compressions library.

## Quick Links

- [GitHub Repository](https://github.com/facebook/zstd)
- [GitHub Releases Page](https://github.com/facebook/zstd/releases)

## Installation Options

On Debian-based Linux distriubutions, zstd can be retrieved with `apt install libzstd-dev libzstd1`.

Otherwise, it's recommended to [build zstd from source using CMake](#building-with-cmake).

### ZSTD Deb Install

`apt install libzstd1 libzsdt-dev`

### Building with CMake

I use Ninja with the MSYS2 MinGW GCC 12.2.0 distribution. Your compiler and build tool may vary.

``` sh
# Clone the repository, OR download and unpack a source archive from the downloads page
git clone git@github.com:facebook/zstd.git --branch v1.5.2
cd zstd
cmake -S build/cmake -B build-mingw -G 'Ninja' -DCMAKE_BUILD_TYPE=Release
# Example build using 10 jobs
cmake --build build-mingw -j10

# Make sure to run the 'install' with administrator privileges. The default install directory will
# require administrator privileges.
cmake --install build-mingw
```

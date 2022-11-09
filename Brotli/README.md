# Brotli

Google's general-purpose lossless compression algorithm.

## Quick Links

- [GitHub Repository](https://github.com/google/brotli)
- [GitHub Releases Page](https://github.com/google/brotli/releases)

## Installation Options

On Debian-based Linux distriubutions, Brotli can be retrieved with `apt install libbrotli1 libbrotli-dev`.

Otherwise, it's recommended to [build Brotli from source using CMake](#building-with-cmake).

### Brotli Deb Install

`apt install libbrotli1 libbrotli-dev`

### Building with CMake

I use Ninja with the MSYS2 MinGW GCC 12.2.0 distribution. Your compiler and build tool may vary.

``` sh
# Clone the repository, OR download and unpack a source archive from the downloads page
git clone git@github.com:google/brotli.git --branch v1.0.9
cd brotli
cmake build-mingw -G 'Ninja' -DCMAKE_BUILD_TYPE=Release
# Example build using 10 jobs
cmake --build build-mingw -j10

# Make sure to run the 'install' with administrator privileges. The default install directory will
# require administrator privileges.
cmake --install build-mingw
```

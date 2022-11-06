<!-- TODO: Fix this to actually document information on ZLIB. I must have reverted it by accident
at some point. -->
# CURL

URL data transfer library which supports a wide number of protocols.

## Quick Links

- [CURL Website](https://curl.se/)
- [CURL Downloads Page](https://curl.se/download.html)
- [GitHub Repository](https://github.com/curl/curl)
- [GitHub Releases Page](https://github.com/curl/curl/releases)

## Installation Options

On Debian-based Linux distriubutions, CURL can be retrieved with `apt install libcurl4-openssl-dev`.

Otherwise, it's recommended to [build CURL from source using CMake](#building-with-cmake).

### CURL Deb Package

`apt install libcurl4-openssl-dev`

### Building with CMake

I use Ninja with the MSYS2 MinGW GCC 12.2.0 distribution. Your compiler and build tool may vary.

``` sh
# Clone the repository, OR download and unpack a source archive from the downloads page
git clone --branch 'curl-7_85_0' git@github.com:curl/curl.git
cd curl
cmake -B build-mingw-shared -G 'Ninja' -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF
# Example build using 10 jobs
cmake --build build-mingw-gcc -j10

# Make sure to run the 'install' with administrator privileges. The default install directory will
# require administrator privileges.
cmake --install build-mingw-gcc
```

# OpenSSL

A widely used cryptography and SSL/TLS toolkit

## Quick Links

- [OpenSSL Website](https://www.openssl.org/)
- [GitHub Repository](https://github.com/openssl/openssl)
- [CMake FindOpenSSL module doc page](https://cmake.org/cmake/help/latest/module/FindOpenSSL.html)

## Installation Options

It is recommended to install OpenSSL using a package manager.

### Debian-based Linux Install

`apt install libssl1.1 libssl-dev`

### Windows Install

#### For MinGW

MinGW users should download the [MSYS2 OpenSSL package](https://packages.msys2.org/package/mingw-w64-x86_64-openssl) using `pacman -S mingw-w64-x86_64-openssl` from within the MSYS shell. (Here's a [link to the package page](https://packages.msys2.org/package/mingw-w64-x86_64-openssl)).
If CMake can't find OpenSSL even after installing it, try setting the `OPENSSL_ROOT_DIR` cache 
variable to the mingw-w64 installation directory.

For example: `cmake -B build -G 'Ninja' -DOPENSSL_ROOT_DIR='C:/msys64/mingw64'`

#### For Clang/MSVC

MSVC/Clang users should install OpenSSL using a package manager like [Conan](https://conan.io/)
or [vcpkg](https://vcpkg.io/en/index.html).
The [Chocolatey](https://chocolatey.org/) `openssl` package also works. For example, `choco install openssl`.

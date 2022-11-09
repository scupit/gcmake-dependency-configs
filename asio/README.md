# asio

## Quick Links

- [OpenSSL Website](https://www.openssl.org/)
- [GitHub Repository](https://github.com/openssl/openssl)

## Installation Options

It is recommended to install OpenSSL using a package manager.

### Debian-based Linux Install

`apt install libasio-dev`

### Windows Install

MinGW users should download the [MSYS2 asio package](https://packages.msys2.org/package/mingw-w64-x86_64-openssl) using `pacman -S mingw-w64-x86_64-asio` from within the MSYS shell.

MSVC/Clang users should install asio using a package manager like [Conan](https://conan.io/)
or [vcpkg](https://vcpkg.io/en/index.html). For example, `vcpkg install asio`.

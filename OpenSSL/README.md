# OpenSSL

A widely used cryptography and SSL/TLS toolkit

## Quick Links

- [OpenSSL Website](https://www.openssl.org/)
- [GitHub Repository](https://github.com/openssl/openssl)

## Installation Options

It is recommended to install OpenSSL using a package manager.

### Debian-based Linux Install

`apt install zlib1g zlib1g-dev`

### Windows Install

MinGW users should download the [MSYS2 OpenSSL package](https://packages.msys2.org/package/mingw-w64-x86_64-openssl) using `pacman -S mingw-w64-x86_64-openssl` from within the MSYS shell.

MSVC/Clang users should install OpenSSL using a package manager like [Conan](https://conan.io/)
or [vcpkg](https://vcpkg.io/en/index.html).
The [Chocolatey](https://chocolatey.org/) `openssl` package also works. For example, `choco install openssl`.

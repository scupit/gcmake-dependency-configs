# GLEW

An OpenGL extension loader library.

## Quick Links

- [GLEW Website](https://glew.sourceforge.net/)
- [GitHub Repository](https://github.com/nigels-com/glew)
- [GitHub Releases Page](https://github.com/nigels-com/glew/releases)

## Downloading the Correct Snapshot

The [Downloads/Build instructions section of the GLEW README](https://github.com/nigels-com/glew#downloads)
recommends building from a release snapshot version. **NOTE** that this does not mean the compressed source
code for any given release, but a compressed version of the repository after GLEW's code generation has run.

> **Good rule of thumb:** After you download and unzip a "release snapshot" of GLEW, the glew directory
> should contain both an `include/` and `lib/` directory, among other things. If it contains both, you
> have correctly downloaded a release snapshot. If it doesn't, you probably downloaded the source
> code directly instead.

For example, you'll want to download [glew-2.2.0.zip](https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0.zip)
on Windows and [glew-2.2.0.tgz](https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0.tgz)
everywhere else.

## Building with CMake

I use ninja with the MSYS2 MinGW GCC 12.2.0 distribution. Your compiler and build tool may vary.

``` sh
# First download and unpack a GLEW snapshot (see above)
cd glew
cmake -S build/cmake -B build-mingw-gcc -G 'Ninja' -DCMAKE_BUILD_TYPE=Release
cmake --build build-mingw-gcc
# Run the 'install' with administrator privileges.
cmake --install build-mingw-gcc
```

# SDL2

From the README:

> Simple DirectMedia Layer is a cross-platform development library designed to provide low level access
> to audio, keyboard, mouse, joystick, and graphics hardware via OpenGL and Direct3D.

## Quick links

- [SDL Website](https://www.libsdl.org/)
- [GitHub Repository](https://github.com/libsdl-org/SDL)

## Building with CMake

I use ninja with the MSYS2 MinGW GCC 12.2.0 distribution. Your compiler and build tool may vary.

``` sh
git clone git@github.com:libsdl-org/SDL.git
cd SDL
cmake -B build-mingw-gcc -G 'Ninja' -DCMAKE_BUILD_TYPE=Release
cmake --build build-mingw-gcc
# This needs to be run with administrator privileges
cmake --install build-mingw-gcc
```

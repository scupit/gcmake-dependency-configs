# SFML

The "Simple and Fast Multimedia Library". From [the SFML website](https://www.sfml-dev.org/):

> SFML provides a simple interface to the various components of your PC, to ease the development of games
> and multimedia applications.

## Quick Links

- [SFML Website](https://www.sfml-dev.org/)
- [GitHub Repository](https://github.com/SFML/SFML)

## Important

**It is recommended to use the `2.6.x` branch instead of the latest release version (currently *2.5.1* or *2.5.x*).**
On Linux, GCMake temporarily changes the value of
[CMAKE_INSTALL_LIBDIR](https://cmake.org/cmake/help/latest/module/GNUInstallDirs.html) so that dependency
libraries are installed to a subdirectory of *lib/*. This is necessary so that dependency libraries of a
project installation do not conflict with or try to overwrite libraries already installed on the system.
The SFML `2.6.x` contains a change to its CMake installation config which allows this to work properly.

See [SFML "State of Development"](https://github.com/SFML/SFML#state-of-development) for links to the branches
themselves plus an explanation on the stability of each.

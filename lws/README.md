# libwebsockets

Basic websocket client and server library written in C.

## Quick Links

- [GitHub Repository](https://github.com/warmcat/libwebsockets)
- ["Release" tags page](https://github.com/warmcat/libwebsockets/tags)

## Installation Options

On Debian-based Linux distriubutions, zstd can be retrieved with `apt install libwebsockets16 libwebsockets-dev`.

Otherwise, it's recommended to [build libwebsockets from source using CMake](#building-with-cmake).

### libwebsockets Deb Install

`apt install libwebsockets16 libwebsockets-dev`

### Building with CMake

I use Ninja with the MSYS2 MinGW GCC 13.2.0 distribution. Your compiler and build tool may vary.

For a library-only installation, I recommend setting these CMake cache variables:

| Cache Variable | Recommended Value | Reasoning |
| -------- | ----- | --------- |
| `LWS_WITHOUT_TESTAPPS` | `ON` | Skip building test executables. |
| `LWS_WITHOUT_TEST_CLIENT` | `ON` | Don't build the test client executable. |
| `LWS_WITHOUT_TEST_PING` | `ON` | Don't build the ping test executable. |
| `LWS_WITHOUT_TEST_SERVER` | `ON` | Don't build the test server executable. |
| `LWS_WITHOUT_TEST_SERVER_EXTPOLL` | `ON` | Don't build the test server (with external poll) executable. |
| `LWS_WITH_MINIMAL_EXAMPLES` | `OFF` | Don't build example executables. |

Also, make sure to set `CMAKE_BUILD_TYPE` to `Release`. It isn't set by default.

In my experience building with MinGW, CMake was unable to find MinGW's OpenSSL installation by default. If you
encounter any sort of error which involves missing OpenSSL files, include dirs, or components, try
setting CMake's `OPENSSL_ROOT_DIR` cache variable to the root directory of your OpenSSL installation.
For example, my MinGW OpenSSL *bin*, *lib*, and *include* directories are all in *C:\\msys64\mingw64*,
so I set it on the command line with `-DOPENSSL_ROOT_DIR='C:/msys64/mingw64'`. Full details
can be found in this project's [OpenSSL dependency configuration README](../openssl/README.md).

``` sh
# Clone the repository, OR download and unpack a source archive from the downloads page
git clone git@github.com:warmcat/libwebsockets.git --branch v4.3.3
cd libwebsockets

# Recommended build command:
# If you encounter OpenSSL-related configuration errors, refer to the paragraph above this
# code block for a possible solution.
cmake -B build -G 'Ninja' -DCMAKE_BUILD_TYPE=Release -DLWS_WITHOUT_TESTAPPS=1 -DLWS_WITHOUT_TEST_CLIENT=1 -DLWS_WITHOUT_TEST_PING=1 -DLWS_WITHOUT_TEST_SERVER=1 -DLWS_WITHOUT_TEST_SERVER_EXTPOLL=1 -DLWS_WITH_MINIMAL_EXAMPLES=0

# Or you can use the basic build command to build everything.
# cmake -B build -G 'Ninja' -DCMAKE_BUILD_TYPE=Release

# Example build using 10 jobs
cmake --build build -j10

# Make sure to run the 'install' with administrator privileges. The default install directory will
# require administrator privileges.
cmake --install build
```

## Further Troubleshooting

I encountered an issue where CMake's find_package call retrieved the libwebsockets build
directory instead of its installation directory. If the CMake cache variable `LWS_SHARED_LIB_FILE`
is `NOT_FOUND` after running a configuration, try deleting the libwebsockets build directory
(not your project's build directory) from the system, then re-configure your CMake project.

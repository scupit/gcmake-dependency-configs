# GCMake External Dependency Configuration

This repository is for configuring C/C++ dependencies to be compatible with
[the gcmake-rust tool](https://github.com/scupit/gcmake-rust).

## Usage

This repository is best explained in the
[gcmake-rust predefined dependency configuration doc page](https://github.com/scupit/gcmake-rust/blob/develop/docs/predefined_dependency_doc.md).

## IMPORTANT NOTES

If using [cppfront](./cppfront/README.md) or [glm](./glm/README.md), make sure to read their corresponding configuration READMEs.
Your build will probably break if you don't.

- [cppfront configuration README](./cppfront/README.md)
- [glm configuration README](./glm/README.md)

## Updating

> **NOTE:** Updating the repo requires a working [gcmake-rust](https://github.com/scupit/gcmake-rust)
> executable.

Run `gcmake-rust dep-config update` to update your local copy of this repository
(in *~/.gcmake/gcmake-dependency-configs*) to the latest version **of the currently checked out branch**,
or to clone the repo if it could not be found. *The repo is cloned to the `develop` branch by default*.

To update and check out a specific branch, use `gcmake-rust dep-config update --to-branch 'the-branch-name'`.
Just **NOTE** that it's recommended to stay on the `develop` branch.

## Building Dependencies

All subdirectory dependencies will be cloned and built automatically as part of your project.

Dependencies which must be manually built and installed each have their own README with build and
installation instructions, and are listed here:

- [asio](./asio/README.md)
- [Brotli](./Brotli/README.md)
- [GLEW](./glew/README.md)
- [libwebsockets](./lws/README.md) (lws)
- [OpenSSL](./openssl/README.md)
- [SDL2](./sdl2/README.md)
- [wxWidgets](./wxwidgets/README.md)
- [ZLIB](./zlib/README.md)
- [zstd](./zstd/README.md)

It's also recommended to use [CCache](https://ccache.dev/) when building large dependencies
like wxWidgets and SDL2, as it can provide massive recompilation speedups. See the
[GCMake doc page on using CCache](https://github.com/scupit/gcmake-rust/blob/develop/docs/using_ccache.md)
for information on how to do that.

[CppFront](https://github.com/hsutter/cppfront) can also be pre-built and installed on the system,
but is generally just be embedded in a project like other subdirectory dependencies. Embedding CppFront
by default makes it easier for other people to build your project in one step, since they most likely
don't have CppFront already installed on their system. See the
[dependency README on cppfront](./cppfront/README.md) and
[documentation on using CppFront with gcmake-rust](https://github.com/scupit/gcmake-rust/blob/develop/docs/cppfront_integration.md) for more information on the topic.

## GCMake Repository Links

- [gcmake-rust](https://github.com/scupit/gcmake-rust): The gcmake C/C++ project configuration tool
- [gcmake-test-project](https://github.com/scupit/gcmake-test-project): The 'test case' project for
    gcmake-rust which also acts as its working example.
- [gcmake-dependency-configs](https://github.com/scupit/gcmake-dependency-configs): The
    [dependency compatibility layer](https://github.com/scupit/gcmake-rust/blob/develop/docs/predefined_dependency_doc.md) repository which allows non-gcmake
    projects to be imported and consumed 'out of the box' by gcmake-rust.

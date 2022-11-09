# GCMake External Dependency Configuration

This repository is for configuring C/C++ dependencies to be compatible with
[the gcmake-rust tool](https://github.com/scupit/gcmake-rust).

## Usage

This repository is best explained in the
[gcmake-rust predefined dependency configuration doc page](https://github.com/scupit/gcmake-rust/blob/develop/docs/predefined_dependency_doc.md).

## Updating

> **NOTE:** Updating the repo requires a working [gcmake-rust](https://github.com/scupit/gcmake-rust)
> executable.

Run `gcmake-rust dep-config update` to update your local copy of this repository
(in *~/.gcmake/gcmake-dependency-configs*) to the latest version **of the currently checked out branch**,
or to clone the repo if it could not be found. *The repo is cloned to the `develop` branch by default*.

To update and check out a specific branch, use `gcmake-rust dep-config update --branch your-branch-name`.

## Building Dependencies

All subdirectory dependencies will be cloned and built automatically as part of your project.

Dependencies which must be manually build and installed each have their own README with build and
installation instructions, and are listed here:

- [asio](./asio/README.md)
- [GLEW](./GLEW/README.md)
- [OpenSSL](./OpenSSL/README.md)
- [SDL2](./SDL2/README.md)
- [wxWidgets](./wxWidgets/README.md)
- [ZLIB](./ZLIB/README.md)
- [zstd](./zstd/README.md)

It's also recommended to use [CCache](https://ccache.dev/) when building large dependencies
like wxWidgets and SDL2, as it can provide massive recompilation speedups.

Those are all CMake projects, so the
[GCMake doc page on using CCache](https://github.com/scupit/gcmake-rust/blob/develop/docs/using_ccache.md)
will be of interest.

## GCMake Repository Links

- [gcmake-rust](https://github.com/scupit/gcmake-rust): The gcmake C/C++ project configuration tool
- [gcmake-test-project](https://github.com/scupit/gcmake-test-project): The 'test case' project for
    gcmake-rust which also acts as its working example.
- [gcmake-dependency-configs](https://github.com/scupit/gcmake-dependency-configs): The
    [dependency compatibility layer](predefined_dependency_doc.md) repository which allows non-gcmake
    projects to be imported and consumed 'out of the box' by gcmake-rust.

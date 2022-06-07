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

## GCMake Repository Links

- [gcmake-rust](https://github.com/scupit/gcmake-rust): The gcmake C/C++ project configuration tool
- [gcmake-test-project](https://github.com/scupit/gcmake-test-project): The 'test case' project for
    gcmake-rust which also acts as its working example.
- [gcmake-dependency-configs](https://github.com/scupit/gcmake-dependency-configs): The
    [dependency compatibility layer](predefined_dependency_doc.md) repository which allows non-gcmake
    projects to be imported and consumed 'out of the box' by gcmake-rust.

# FreeType

[FreeType](https://freetype.org/index.html) is an amazing, widely supported font rendering library.

Website: <https://freetype.org/index.html>

## Specifying version/tag

FreeType tags are formatted interestingly. See their
[GitLab tags page](https://gitlab.freedesktop.org/freetype/freetype/-/tags) for the full tag list.

As of writing this commit, the latest release tag is `VER-2-12-1`. Example usage:

``` yaml
predefined_dependencies:
  FreeType:
    git_tag: VER-2-12-1
    # You can also just use
    # git_tag: origin/master
```

# Crow

A C++ HTTP/Websocket web service framework.

## Must use the master branch

**You must use the `master` branch, otherwise the dep configuration will not work.**
The current release (as of writing this README) is
[v1.0+5 Security Patch](https://github.com/CrowCpp/Crow/releases/tag/v1.0%2B5) on August 24th.
That release depends on Boost, while the master branch doesn't.

That being said, the coming release (after *v1.0+5*) would be able to be used.

## READ THIS

The build will not initially work out-of-the-box. Crow's call to *find_package(asio)* conflicts
with ours, since ours has some extra functionality. I haven't found a way to disable theirs from our code
yet, so this temporary solution will have to do for now.

Once *Crow* has successfully been cloned, open *dep/Crow/CMakeLists.txt* and change the line:

``` cmake
find_package( asio REQUIRED )
```

to

``` cmake
if( NOT TARGET asio::asio )
  find_package( asio REQUIRED )
endif()
```

This will cause Crow to use our asio target instead of the one it would otherwise create. This is kind of an
annoying solution, but for now it works. Maybe I'll open a pull request to see if that bit can be changed.

To put these info practice, try building the
["using-crow" example project](https://github.com/scupit/gcmake-test-project/tree/develop/using-crow).

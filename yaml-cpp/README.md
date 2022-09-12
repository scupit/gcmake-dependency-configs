# yaml-cpp

## Important Note

**Use the `master` branch of yaml-cpp instead of the latest `yaml-cpp-0.7.0` branch.**
cmake_dependent_option currently force overrides YAML_CPP_INSTALL by hiding the option
completely (see the issue at <https://gitlab.kitware.com/cmake/cmake/-/issues/22909>)
on the yaml-cpp-0.7.0 branch. This issue is not present on the master branch.
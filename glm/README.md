# glm

Repository link: [https://github.com/g-truc/glm](https://github.com/g-truc/glm)

## Important

When using glm as a project dependency, *make sure to use the* **master** *branch instead of the*
*latest release (currently 0.9.9.8)*. The master branch has important CMakeLists.txt changes which
correctly install glm's headers when installing in a gcmake project. This dependency config is currently
set to use [my fork of glm](https://github.com/scupit/glm) which provides the GLM_INSTALL option, which allows
consumers to select whether the install target for GLM is created.

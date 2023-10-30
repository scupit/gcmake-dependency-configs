if( USING_EMSCRIPTEN )
  set( PLATFORM "Web" CACHE STRING "raylib platform is set to 'Web' when building with Emscripten." FORCE )
endif()

set( USE_EXTERNAL_GLFW "OFF" CACHE STRING "Set to OFF by GCMake. We actually are using external GLFW, but this avoids an unnecesary find_package call in raylib. glfw3_FOUND is set by GCMake so that raylib still links against GLFW targets. See raylib's Glfwimport.cmake file for details.")
set( glfw3_FOUND TRUE CACHE BOOL "Set to TRUE by GCMake. Ensures raylib links against glfw targets." )

# Don't FORCE this one, since BUILD_EXAMPLES is a pretty general variable name
# and could be set by other external project CMake code.
set( BUILD_EXAMPLES FALSE CACHE BOOL "Set to OFF so raylib examples aren't built." )
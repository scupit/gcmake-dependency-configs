# GLEW_DIR will be set if CMake found GLEW using find_package CONFIG mode search.
if( WIN32 )
  if( GLEW_DIR )
    # It's run in config mode
    string( REGEX REPLACE
      "lib.*$"
      "bin"
      GLEW_BIN_PATH
      "${GLEW_DIR}"
    )
    message("${GLEW_BIN_PATH}")
    find_file( GLEW_SHARED_LIB_FILE
      NAMES
        glew32.dll
        libglew32.dll
        GLEW.so
        libGLEW.so
        glew.so
        libglew.so
      PATHS
        "${GLEW_BIN_PATH}"
      NO_PACKAGE_ROOT_PATH
      NO_CMAKE_PATH
      NO_CMAKE_ENVIRONMENT_PATH
      NO_SYSTEM_ENVIRONMENT_PATH
      NO_CMAKE_SYSTEM_PATH
    )
  else()
    # It's run in module mode
    set( GLEW_SHARED_LIB_FILE "${GLEW_SHARED_LIBRARY}")
  endif()

  if( GLEW_SHARED_LIB_FILE AND NOT TARGET copy-glew-shared )
    add_custom_target( copy-glew-shared ALL
      COMMAND
        ${CMAKE_COMMAND} -E copy "${GLEW_SHARED_LIB_FILE}" "${MY_RUNTIME_OUTPUT_DIR}"
    )
    add_to_needed_files_list( "${GLEW_SHARED_LIB_FILE}" )
  endif()
endif()
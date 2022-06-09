# The GLEW DLL is found just fine on Linux when built from source and installed.
# However, it must be copied over on windows. This finds the DLL on windows and
# installs it.
if( WIN32 )
  set( GLEW_WIN_SHOULD_COPY_DLL ON CACHE BOOL "(Windows Only) whether to automatically copy the GLEW DLL to the build and install directories, when needed." )

  if( GLEW_WIN_SHOULD_COPY_DLL )
    # GLEW_DIR will be set if CMake found GLEW using find_package CONFIG mode search.
    if( GLEW_DIR )
      # It's run in config mode
      string( REGEX REPLACE
        "lib.*$"
        "bin"
        GLEW_BIN_PATH
        "${GLEW_DIR}"
      )

      find_file( GLEW_SHARED_LIB_FILE
        NAMES
          # Only search for DLL files, since we only need to copy these on Windows.
          glew32.dll
          libglew32.dll
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
endif()
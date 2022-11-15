if( TARGET_SYSTEM_IS_WINDOWS )
  set( SDL2_WIN_SHOULD_COPY_DLL ON CACHE BOOL "(Windows Only) whether to automatically copy the SDL2.dll to the build and install directories, when needed." )

  if( SDL2_FOUND AND SDL2_WIN_SHOULD_COPY_DLL )
    find_file( SDL2_SHARED_LIB_FILE
      NAMES
        # Only search for DLL files, since we only need to copy these on Windows.
        SDL2.dll
      PATHS
        "${SDL2_BINDIR}"
      NO_PACKAGE_ROOT_PATH
      NO_CMAKE_PATH
      NO_CMAKE_ENVIRONMENT_PATH
      NO_SYSTEM_ENVIRONMENT_PATH
      NO_CMAKE_SYSTEM_PATH
    )

    if( SDL2_SHARED_LIB_FILE AND NOT TARGET copy-sdl2-shared )
      add_custom_target( copy-sdl2-shared ALL
        COMMAND
          ${CMAKE_COMMAND} -E copy "${SDL2_SHARED_LIB_FILE}" "${MY_RUNTIME_OUTPUT_DIR}"
      )
      if( DEFINED PROJECT_SDL2_INSTALL_MODE )
        add_to_needed_bin_files_list( "${SDL2_SHARED_LIB_FILE}" )
      endif()
    endif()
  endif()
endif()
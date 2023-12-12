if( TARGET_SYSTEM_IS_WINDOWS AND NOT ALREADY_CONFIGURED_LWS )
  set( LWS_WIN_SHOULD_COPY_DLL ON CACHE BOOL "(Windows Only) whether to automatically copy libwebsockets.dll to the build and install directories, when needed." )

  if( libwebsockets_FOUND AND LWS_WIN_SHOULD_COPY_DLL )
    find_file( LWS_SHARED_LIB_FILE
      NAMES
        "libwebsockets.dll"
      PATHS
        "${libwebsockets_DIR}/../bin"
      NO_PACKAGE_ROOT_PATH
      NO_CMAKE_PATH
      NO_CMAKE_ENVIRONMENT_PATH
      NO_SYSTEM_ENVIRONMENT_PATH
      NO_CMAKE_SYSTEM_PATH
      REQUIRED
    )

    # TODO: Standardize this error check into a function. I do this same thing in many configurations.
    if( NOT LWS_SHARED_LIB_FILE )
      cmake_path( GET libwebsockets_DIR PARENT_PATH _lib_base_path )
      message( FATAL_ERROR "Unable to find libwebsockets.dll while looking in path \"${_lib_base_path}/bin/${the_file_base_name}.dll\". Does the DLL file exist?")
    endif()

    if( NOT TARGET copy-lws-shared )
      add_custom_target( copy-lws-shared ALL
        COMMAND
          ${CMAKE_COMMAND} -E copy "${LWS_SHARED_LIB_FILE}" "${MY_RUNTIME_OUTPUT_DIR}"
      )
      if( DEFINED PROJECT_LWS_INSTALL_MODE )
        add_to_needed_bin_files_list( "${LWS_SHARED_LIB_FILE}" )
      endif()
    endif()
  endif()

  set( ALREADY_CONFIGURED_LWS TRUE )
endif()
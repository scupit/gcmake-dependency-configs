if( TARGET_SYSTEM_IS_WINDOWS )
  if( NOT CURL_DIR )
    message( FATAL_ERROR "GCMake Error: Found a version of curl not installed using CMake. On Windows, GCMake requires that CURL was installed on the system using CMake." )
  endif()

  get_target_property( curl_lib_type CURL::libcurl TYPE )

  if( curl_lib_type STREQUAL "SHARED_LIBRARY" )
    find_file( GCMAKE_FILE_libcurl_dll
      NAMES
        "libcurl.dll"
      PATHS
        "${CURL_DIR}/../../../bin"
      NO_CMAKE_ENVIRONMENT_PATH
      NO_CMAKE_FIND_ROOT_PATH
      NO_CMAKE_PATH
      NO_SYSTEM_ENVIRONMENT_PATH
      NO_CMAKE_SYSTEM_PATH
      NO_PACKAGE_ROOT_PATH
    )

    if( NOT GCMAKE_FILE_libcurl_dll )
      message( FATAL_ERROR "Unable to determine the location of libcurl.dll" )
    endif()

    if( NOT TARGET copy-libcurl-shared )
      add_custom_target( copy-libcurl-shared ALL
        COMMAND
          ${CMAKE_COMMAND} -E copy "${GCMAKE_FILE_libcurl_dll}" "${MY_RUNTIME_OUTPUT_DIR}"
      )

      if( DEFINED PROJECT_CURL_INSTALL_MODE )
        add_to_needed_bin_files_list( "${GCMAKE_FILE_libcurl_dll}" )
      endif()
    endif()
  endif()
endif()

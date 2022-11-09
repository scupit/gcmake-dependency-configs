
if( TARGET_SYSTEM_IS_WINDOWS AND NOT ALREADY_CONFIGURED_ZSTD )
  if( ZSTD_WINDOWS_SHARED_IMPORT_LIB )
    cmake_path( GET ZSTD_WINDOWS_SHARED_IMPORT_LIB STEM the_file_base_name )
    cmake_path( GET ZSTD_WINDOWS_SHARED_IMPORT_LIB PARENT_PATH lib_dir_path )

    find_file( GCMAKE_ZSTD_DLL
      NAMES "${the_file_base_name}.dll"
      PATHS "${lib_dir_path}/../bin"
      NO_DEFAULT_PATH
      NO_PACKAGE_ROOT_PATH
      NO_CMAKE_ENVIRONMENT_PATH
      NO_SYSTEM_ENVIRONMENT_PATH
      NO_CMAKE_SYSTEM_PATH
    )

    if( NOT GCMAKE_ZSTD_DLL )
      cmake_path( GET lib_dir_path PARENT_PATH _lib_base_path )
      message( FATAL_ERROR "Unable to find zstd dll to copy while looking for \"${_lib_base_path}/bin/${the_file_base_name}.dll\". Does the file exist?")
    endif()

    if( NOT TARGET _copy_zstd_dlls )
      add_custom_target( _copy_zstd_dlls ALL
        COMMAND
          ${CMAKE_COMMAND} -E copy "${GCMAKE_ZSTD_DLL}" "${MY_RUNTIME_OUTPUT_DIR}"
      )

      if( DEFINED PROJECT_zstd_INSTALL_MODE )
        add_to_needed_bin_files_list( "${GCMAKE_ZSTD_DLL}" )
      endif()
    endif()
  endif()

  set( ALREADY_CONFIGURED_ZSTD TRUE )
endif()

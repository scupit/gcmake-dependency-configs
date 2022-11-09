
if( TARGET_SYSTEM_IS_WINDOWS AND NOT ALREADY_CONFIGURED_BROTLI )
  list( LENGTH BROTLI_WINDOWS_SHARED_IMPORT_LIBRARIES _brotli_has_shared_libraries_to_copy )

  if( _brotli_has_shared_libraries_to_copy )
    set( _BROTLI_DLLS_TO_COPY )

    foreach( _brotli_import_lib IN LISTS BROTLI_WINDOWS_SHARED_IMPORT_LIBRARIES )
      cmake_path( GET _brotli_import_lib STEM the_file_base_name )
      cmake_path( GET _brotli_import_lib PARENT_PATH lib_dir_path )

      find_file( GCMAKE_BROTLI_DLL_${the_file_base_name}
        NAMES "${the_file_base_name}.dll"
        PATHS "${lib_dir_path}/../bin"
        NO_DEFAULT_PATH
        NO_PACKAGE_ROOT_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
      )

      if( GCMAKE_BROTLI_DLL_${the_file_base_name} )
        mark_as_advanced( GCMAKE_BROTLI_DLL_${the_file_base_name} )
        list( APPEND _BROTLI_DLLS_TO_COPY "${GCMAKE_BROTLI_DLL_${the_file_base_name}}" )
      else()
        cmake_path( GET lib_dir_path PARENT_PATH _lib_base_path )
        message( FATAL_ERROR "Unable to find brotli dll to copy while looking for \"${_lib_base_path}/bin/${the_file_base_name}.dll\". Does the file exist?")
      endif()
    endforeach()

    if( NOT TARGET _copy_brotli_dlls )
      add_custom_target( _copy_brotli_dlls ALL
        COMMAND
          ${CMAKE_COMMAND} -E copy "$<JOIN:\"${_BROTLI_DLLS_TO_COPY}\",\" \">" "${MY_RUNTIME_OUTPUT_DIR}"
      )

      if( DEFINED PROJECT_Brotli_INSTALL_MODE )
        foreach( needed_brotli_dll IN LISTS _BROTLI_DLLS_TO_COPY )
          add_to_needed_bin_files_list( "${needed_brotli_dll}" )
        endforeach()
      endif()
    endif()
  endif()

  set( ALREADY_CONFIGURED_BROTLI TRUE )
endif()

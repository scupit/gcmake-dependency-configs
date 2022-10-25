
# We don't have to take Config mode into account because ZLIB doesn't create a CMake config file.
if( TARGET_SYSTEM_IS_WINDOWS AND NOT ALREADY_CONFIGURED_ZLIB )
  set( _zlib_dll_paths )

  # ZLIB_LIBRARIES should only contain one library as far as I'm aware. However, treat it like a list
  # just in case.
  foreach( lib_path IN LISTS ZLIB_LIBRARIES )
    cmake_path( GET lib_path EXTENSION the_extension )

    if( the_extension MATCHES "dll" )
      cmake_path( GET lib_path STEM the_file_base_name )
      cmake_path( GET lib_path PARENT_PATH lib_dir_path )

      set( _ZLIB_DLL_NAMES
        "z.dll"
        "libzlib.dll"
        "zlib.dll"
        "zdll.dll"
        "zlib1.dll"
        "zlibwapi.dll"
        "zlibvc.dll"
      )

      find_file( GCMAKE_ZLIB_DLL_${the_file_base_name}
        NAMES ${_ZLIB_DLL_NAMES}
        PATHS "${lib_dir_path}/../bin"
        # NO_CACHE
        NO_DEFAULT_PATH
        NO_PACKAGE_ROOT_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
      )

      if( GCMAKE_ZLIB_DLL_${the_file_base_name} )
        list( APPEND _zlib_dll_paths "${GCMAKE_ZLIB_DLL_${the_file_base_name}}" )
      else()
        message( FATAL_ERROR "Unable to find a zlib DLL" )
      endif()
    endif()
  endforeach()

  list( REMOVE_DUPLICATES _zlib_dll_paths )
  list( LENGTH _zlib_dll_paths _num_dlls_to_copy )

  if( _num_dlls_to_copy )
    add_custom_target( _copy-zlib-dlls ALL
      COMMAND
        ${CMAKE_COMMAND} -E copy "$<JOIN:\"${_zlib_dll_paths}\",\" \">" "${MY_RUNTIME_OUTPUT_DIR}"
    )

    foreach( dll_file IN LISTS _zlib_dll_paths )
      if( DEFINED PROJECT_ZLIB_INSTALL_MODE )
        add_to_needed_bin_files_list( "${dll_file}" )
      endif()
    endforeach()
  endif()

  set( ALREADY_CONFIGURED_ZLIB TRUE )
endif()
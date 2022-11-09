# We don't have to take Config mode into account because OpenSSL doesn't create a CMake config file.
if( TARGET_SYSTEM_IS_WINDOWS AND NOT ALREADY_CONFIGURED_OPENSSL )
  set( _openssl_dll_paths )

  foreach( lib_path IN LISTS OPENSSL_LIBRARIES )
    cmake_path( GET lib_path FILENAME lib_file_name )

    if( NOT lib_file_name MATCHES "static" )
      cmake_path( GET lib_path STEM the_file_base_name )
      cmake_path( GET lib_path PARENT_PATH lib_dir_path )

      file( GLOB maybe_matching_dll "${lib_dir_path}/../bin/${the_file_base_name}*.dll" )

      list( LENGTH maybe_matching_dll _has_matching_dll )
      if( _has_matching_dll )
        list( GET maybe_matching_dll 0 the_matching_dll )
        cmake_path( ABSOLUTE_PATH the_matching_dll )
        set( GCMAKE_OPENSSL_DLL_${the_file_base_name} "${the_matching_dll}" )
      endif()

      if( GCMAKE_OPENSSL_DLL_${the_file_base_name} )
        list( APPEND _openssl_dll_paths "${GCMAKE_OPENSSL_DLL_${the_file_base_name}}" )
      else()
        message( FATAL_ERROR "Unable to find OpenSSL's \"${the_file_base_name}.dll\"" )
      endif()
    endif()
  endforeach()

  list( REMOVE_DUPLICATES _openssl_dll_paths )
  list( LENGTH _openssl_dll_paths _num_dlls_to_copy )

  if( _num_dlls_to_copy AND NOT TARGET _copy-openssl-dlls )
    add_custom_target( _copy-openssl-dlls ALL
      COMMAND
        ${CMAKE_COMMAND} -E copy "$<JOIN:\"${_openssl_dll_paths}\",\" \">" "${MY_RUNTIME_OUTPUT_DIR}"
    )

    foreach( dll_file IN LISTS _openssl_dll_paths )
      if( DEFINED PROJECT_OPENSSL_INSTALL_MODE )
        add_to_needed_bin_files_list( "${dll_file}" )
      endif()
    endforeach()
  endif()

  set( ALREADY_CONFIGURED_OPENSSL TRUE )
endif()
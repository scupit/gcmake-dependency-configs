if( WIN32 AND wxWidgets_LIB_DIR )
  set( WX_LIB_LIST "${wxWidgets_LIBRARIES" )
  
  # All wxWidgets library files are listed as absolute paths. System libraries won't have a slash.
  list( FILTER WX_LIB_LIST INCLUDE REGEX "/" )
  string( REGEX REPLACE
    "\\.(a|lib)"
    ""
    WX_LIB_LIST
    "${WX_LIB_LIST}"
  )

  string( REGEX MATCH "dll/?$" WX_IS_USING_DLLS "${wxWidgets_LIBRARY_DIR}" )

  if( WX_IS_USING_DLLS )
    set( WX_DLLS_TO_COPY "" )

    foreach( absolute_lib_file_without_extension IN LISTS WX_LIB_LIST )
      file( GLOB WX_ALL_DLL_ABSOLUTE_PATHS "${wxWidgets_LIB_DIR}" )
      string( REGEX MATCH
        "${absolute_lib_file_without_extension}\\.*.dll"
        MATCHING_WX_DLL_ABSOLUTE_PATH
        "${WX_ALL_DLL_ALL_ABSOLUTE_PATHS}"
      )
      string( LENGTH "${MATCHING_WX_DLL_ABSOLUTE_PATH}" DOES_DLL_EXIST )

      if( DOES_DLL_EXIST )
        set( WX_DLLS_TO_COPY "${WX_DLLS_TO_COPY}" "${MATCHING_WX_DLL_ABSOLUTE_PATH}" )
        add_to_needed_files_list( "${MATCHING_WX_DLL_ABSOLUTE_PATH}" )
      else()
        message( FATAL_ERROR "This project (${PROJECT_NAME}) is using wxWidgets as a DLL/Shared library. However, a DLL starting with ${absolute_lib_file_without_extension} could not be found." )
      endif()

      if( NOT TARGET wx-copy-dlls )
        add_custom_target( wx-copy-dlls ALL
          COMMAND
            ${CMAKE_COMMAND} -E copy "${WX_DLLS_TO_COPY}" "${MY_RUNTIME_OUTPUT_DIR}"
        )
      endif()
    endforeach()
  endif()
endif()
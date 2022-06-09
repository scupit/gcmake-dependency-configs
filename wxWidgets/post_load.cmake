include( ${wxWidgets_USE_FILE} )

if( WIN32 AND wxWidgets_LIB_DIR AND NOT TARGET copy-wx-dlls )

  string( REGEX MATCH "dll/?$" WX_IS_USING_DLLS "${wxWidgets_LIB_DIR}" )

  if( WX_IS_USING_DLLS )
    set( WX_USED_LIB_NAMES "${wxWidgets_LIBRARIES}" )
    
    # All wxWidgets library files are listed as absolute paths. System libraries won't have a slash.
    list( FILTER WX_USED_LIB_NAMES INCLUDE REGEX "/" )
    string( REGEX REPLACE
      "\\.(a|lib)"
      ""
      WX_USED_LIB_NAMES
      "${WX_USED_LIB_NAMES}"
    )
    string( REPLACE
      "${wxWidgets_LIB_DIR}"
      ""
      WX_USED_LIB_NAMES
      "${WX_USED_LIB_NAMES}"
    )

    foreach( lib_name IN LISTS WX_USED_LIB_NAMES )
      string( REGEX REPLACE
        "^/?lib"
        ""
        lib_name
        "${lib_name}"
      )

      string( REGEX MATCH
        "^[a-z]+"
        the_prefix_without_version
        "${lib_name}"
      )

      string( REGEX MATCH
        "_[a-z]+$"
        the_component
        "${lib_name}"
      )

      set( WAS_THE_WX_DLL_FOUND FALSE )
      set( PREFIXES_TO_SEARCH "${the_prefix_without_version}" "lib${the_prefix_without_version}" )

      foreach( prefix_searching IN LISTS PREFIXES_TO_SEARCH )

        if( NOT WAS_THE_WX_DLL_FOUND )
          file( GLOB WX_ALL_DLL_ABSOLUTE_PATHS "${wxWidgets_LIB_DIR}/*.dll" )

          set( ALL_RELATIVE_DLL_PATHS_NO_PREFIX "${WX_ALL_DLL_ABSOLUTE_PATHS}" )
          # set( full_prefix_regex "${prefix_searching}[0-9]+[a-z]*_" )
          set( full_prefix_regex "[a-z]+[0-9]+[a-z]*_" )
          
          foreach( suffix_checking IN LISTS ALL_RELATIVE_DLL_PATHS_NO_PREFIX )
            if( NOT WX_DLL_SUFFIX )
              string( REPLACE "${wxWidgets_LIB_DIR}/" "" suffix_checking "${suffix_checking}" )
              string( REGEX REPLACE "${full_prefix_regex}" "" suffix_checking "${suffix_checking}" )

              set( rel_paths_list_copy "${ALL_RELATIVE_DLL_PATHS_NO_PREFIX}" )

              list( FILTER rel_paths_list_copy
                INCLUDE REGEX "${suffix_checking}"
              )

              list( LENGTH rel_paths_list_copy length_of_copy_list )
              list( LENGTH ALL_RELATIVE_DLL_PATHS_NO_PREFIX length_of_original_list )

              if( length_of_copy_list EQUAL length_of_original_list )
                set( WX_DLL_SUFFIX "${suffix_checking}" )
              endif()
            endif()
          endforeach()

          if( NOT WX_DLL_SUFFIX )
            message( FATAL_ERROR "Could not determine wxWidgets dll vendor suffix." )
          endif()

          set( WX_ALL_RELATIVE_DLL_PATHS "${WX_ALL_DLL_ABSOLUTE_PATHS}")
          string( REPLACE "${wxWidgets_LIB_DIR}/" "" WX_ALL_RELATIVE_DLL_PATHS "${WX_ALL_RELATIVE_DLL_PATHS}" )

          if( the_component )
            set( the_regex_searching "${prefix_searching}[0-9]+[a-z]*_?${the_component}_${WX_DLL_SUFFIX}")
          else()
            set( the_regex_searching "${prefix_searching}[0-9]+[a-z]*_${WX_DLL_SUFFIX}")
          endif()

          list( FILTER WX_ALL_RELATIVE_DLL_PATHS
            INCLUDE REGEX "${the_regex_searching}"
          )

          set( MATCHED_WX_DLL_NAME "${WX_ALL_RELATIVE_DLL_PATHS}" )
          string( LENGTH "${MATCHED_WX_DLL_NAME}" DOES_DLL_EXIST )

          if( DOES_DLL_EXIST )
            set( MATCHED_WX_DLL "${wxWidgets_LIB_DIR}/${MATCHED_WX_DLL_NAME}" )
            list( APPEND WX_DLLS_TO_COPY "${MATCHED_WX_DLL}" )
            add_to_needed_files_list( "${MATCHED_WX_DLL}" )
            set( WAS_THE_WX_DLL_FOUND TRUE )
          endif()
        endif()
      endforeach()

      if( NOT WAS_THE_WX_DLL_FOUND )
        message( FATAL_ERROR "This project (${PROJECT_NAME}) is using wxWidgets as a DLL/Shared library. However, a DLL named one of '${PREFIXES_TO_SEARCH}' could not be found in ${wxWidgets_LIB_DIR}." )
      endif()
    endforeach()

    # message( "WX DLLs to copy: ${WX_DLLS_TO_COPY}")

    add_custom_target( copy-wx-dlls ALL
      COMMAND
        ${CMAKE_COMMAND} -E copy "$<JOIN:\"${WX_DLLS_TO_COPY}\",\" \">" "${MY_RUNTIME_OUTPUT_DIR}"
    )
  endif()
endif()
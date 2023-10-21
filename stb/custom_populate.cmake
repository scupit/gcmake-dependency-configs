
set( stb_RELATIVE_DEP_PATH "dep/stb" )
set( stb_DEP_DIR "${stb_SOURCE_DIR}")
set( stb_INCLUDE_DIR "${stb_DEP_DIR}" )

# In this 'dependency configuration' context, the current source directory and the toplevel
# source directory are always the same. This is because dependencies are only configured in the project root.
# However, we'll use the toplevel project dir variables for clarity.

# set( stb_DEP_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${stb_RELATIVE_DEP_PATH}" )
# set( stb_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${stb_RELATIVE_DEP_PATH}" )

function( populate_stb_lib
  target_name
  header_name_list
)
  if( NOT TARGET stb_${target_name} )
    list( GET header_name_list 0 first_header_name )
    string( REPLACE
      ".h"
      "_header"
      stb_header_item
      "${first_header_name}"
    )

    find_file( ${stb_header_item}
      REQUIRED
      NO_CACHE
      NAMES
        ${header_name_list}
      PATHS
        "${stb_DEP_DIR}"
    )

    gcmake_wrap_dep_files_in_generators( ${stb_header_item} stb_h_files_b stb_h_files_i )

    add_library( stb_${target_name} INTERFACE )
    target_include_directories( stb_${target_name}
      SYSTEM
      INTERFACE
        "$<BUILD_INTERFACE:${stb_INCLUDE_DIR}>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${stb_RELATIVE_DEP_PATH}>"
    )

    target_sources( stb_${target_name}
      INTERFACE
        FILE_SET HEADERS
          BASE_DIRS "${stb_INCLUDE_DIR}"
          FILES ${stb_h_files_b} ${stb_h_files_i}
    )

    # TODO: Should this use 'TARGET_SYSTEM_IS_LINUX'? (or target system is unix?)
    if( CURRENT_SYSTEM_IS_LINUX AND (USING_GCC OR USING_CLANG) )
      target_link_libraries( stb_${target_name}
        # Need to link the math library
        INTERFACE m
      )
    endif()

    add_library( stb::${target_name} ALIAS stb_${target_name} )
  endif()
endfunction()

populate_stb_lib( image "stb_image.h" )
populate_stb_lib( image_write "stb_image_write.h" )
populate_stb_lib( image_resize "stb_image_resize.h;stb_image_resize2.h" )
populate_stb_lib( divide "stb_divide.h" )

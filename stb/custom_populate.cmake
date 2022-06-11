
set( stb_RELATIVE_DEP_PATH "dep/stb" )
set( stb_DEP_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${stb_RELATIVE_DEP_PATH}" )
set( stb_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${stb_RELATIVE_DEP_PATH}" )

function( populate_stb_lib
  target_name
  header_name
)
  if( NOT TARGET stb_${target_name} )
    string( REPLACE
      ".h"
      "_header"
      stb_header_item
      "${header_name}"
    )

    find_file( ${stb_header_item}
      REQUIRED
      NAMES
        ${header_name}
      PATHS
        "${stb_DEP_DIR}"
    )

    get_without_source_dir_prefix( "${${stb_header_item}}" stb_header_item_install )
    make_generators( "${${stb_header_item}}" "${stb_header_item_install}" stb_h_files )

    # add_library( stb_${target_name} INTERFACE IMPORTED )
    add_library( stb_${target_name} INTERFACE )
    target_include_directories( stb_${target_name} INTERFACE
      "$<BUILD_INTERFACE:${stb_INCLUDE_DIR}>"
      "$<INSTALL_INTERFACE:include/${stb_RELATIVE_DEP_PATH}>"
    )
    target_sources( stb_${target_name}
      INTERFACE
        FILE_SET HEADERS
          FILES ${stb_h_files_b} ${stb_h_files_i}
    )

    # add_library( stb::${target_name} ALIAS stb__${target_name} )
  endif()
endfunction()

populate_stb_lib( image "stb_image.h" )
populate_stb_lib( image_write "stb_image_write.h" )
populate_stb_lib( image_resize "stb_image_resize.h" )
populate_stb_lib( divide "stb_divide.h" )

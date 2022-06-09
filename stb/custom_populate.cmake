set( STB_DEP_DIR "${CMAKE_CURRENT_SOURCE_DIR}/dep/stb" )
set( STB_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/dep/stb" )

function( populate_stb_lib
  target_name
  header_name
)
  if( NOT TARGET ${target_name} )
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
        "${STB_DEP_DIR}"
    )

    add_library( ${target_name} INTERFACE IMPORTED )
    target_include_directories( ${target_name} INTERFACE "${STB_INCLUDE_DIR}" )
    target_sources( ${target_name}
      INTERFACE
        FILE_SET HEADERS
          FILES "${stb_header_item}"
    )
  endif()
endfunction()

populate_stb_lib( stb::image "stb_image.h" )
populate_stb_lib( stb::image_write "stb_image_write.h" )
populate_stb_lib( stb::image_resize "stb_image_resize.h" )
populate_stb_lib( stb::divide "stb_divide.h" )

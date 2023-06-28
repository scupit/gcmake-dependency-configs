
set( imgui_RELATIVE_DEP_PATH "dep/imgui" )
set( imgui_DEP_DIR "${imgui_SOURCE_DIR}" )
set( imgui_INCLUDE_DIR "${imgui_DEP_DIR}" )
set( imgui_BACKENDS_DIR "${imgui_DEP_DIR}/backends" )

# In this 'dependency configuration' context, the current source directory and the toplevel
# source directory are always the same. This is because dependencies are only configured in the project root.
# However, we'll use the toplevel project dir variables for clarity.

# set( imgui_DEP_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${imgui_RELATIVE_DEP_PATH}" )
# set( imgui_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${imgui_RELATIVE_DEP_PATH}" )

function( _populate_imgui_backends )
  # Currently, only a subset of backends is supported.
  # Add 'apple' once I'm able to test on MacOS.
  set( IMGUI_SYSTEMS
    android
    emscripten
    glfw
    sdl
    win32
  )

  set( IMGUI_APIS
    wgpu
    opengl3
    opengl2
    vulkan
    sdlrenderer
    dx9
    dx10
    dx11
    dx12
  )

  foreach( sys IN LISTS IMGUI_SYSTEMS )
    set( _imgui_${sys}_sources "${imgui_BACKENDS_DIR}/imgui_impl_${sys}.cpp" )
    set( _imgui_${sys}_headers "${imgui_BACKENDS_DIR}/imgui_impl_${sys}.h" )

    # im_<SYS>_sources_b
    # im_<SYS>_sources_i
    # im_<SYS>_headers_i
    # im_<SYS>_headers_b
    gcmake_wrap_dep_files_in_generators( _imgui_${sys}_sources im_${sys}_sources_b im_${sys}_sources_i )
    gcmake_wrap_dep_files_in_generators( _imgui_${sys}_headers im_${sys}_headers_b im_${sys}_headers_i )
  endforeach()

  foreach( api IN LISTS IMGUI_APIS )
    set( _imgui_${api}_sources "${imgui_BACKENDS_DIR}/imgui_impl_${api}.cpp" )
    set( _imgui_${api}_headers "${imgui_BACKENDS_DIR}/imgui_impl_${api}.h" )

    if( api STREQUAL "opengl3" )
      list( APPEND imgui_${api}_headers "${imgui_BACKENDS_DIR}/imgui_impl_opengl3_loader.h" )
    endif()

    # im_<API>_sources_b
    # im_<API>_sources_i
    # im_<API>_headers_i
    # im_<API>_headers_b
    gcmake_wrap_dep_files_in_generators( _imgui_${api}_sources im_${api}_sources_b im_${api}_sources_i )
    gcmake_wrap_dep_files_in_generators( _imgui_${api}_headers im_${api}_headers_b im_${api}_headers_i )
  endforeach()

  # Map system to supported APIs
  set( im_android opengl3 opengl2 )
  set( im_emscripten opengl3 wgpu )
  set( im_glfw opengl3 opengl2 vulkan )
  set( im_sdl opengl3 opengl2 vulkan dx9 dx10 dx11 dx12 sdlrenderer )
  set( im_win32 dx9 dx10 dx11 dx12 )

  set( alias_dx9 directx9 )
  set( alias_dx10 directx10 )
  set( alias_dx11 directx11 )
  set( alias_dx12 directx12 )
  set( alias_wgpu webgpu )

  foreach( sys IN LISTS IMGUI_SYSTEMS )
    foreach( api IN LISTS im_${sys} )
      list( FIND IMGUI_APIS ${api} api_index )

      if( api_index LESS 0 )
        message( FATAL_ERROR "Error while setting up IMGUI targets: rendering API '${api}' was listed under system '${sys}', but not in the full IMGUI suppored APIs list.")
      endif()

      if( DEFINED alias_${api} )
        set( resolved_api_name ${alias_${api}} )
      else()
        set( resolved_api_name ${api} )
      endif()

      set( new_imgui_target_name imgui_${sys}_${resolved_api_name} )

      if( NOT TARGET ${new_imgui_target_name} )
        add_library( ${new_imgui_target_name} INTERFACE )
        add_library( imgui::${sys}_${resolved_api_name} ALIAS ${new_imgui_target_name} )

        # Fixes the "undefined reference to symbol 'dlsym@@GLIBC_2.x.x'" linker error.
        if( sys STREQUAL "sdl" OR api MATCHES "opengl" )
          target_link_libraries( ${new_imgui_target_name} INTERFACE "$<$<BOOL:${TARGET_SYSTEM_IS_LINUX}>:-ldl>" )
        endif()

        target_include_directories( ${new_imgui_target_name}
          SYSTEM
          INTERFACE
            "$<BUILD_INTERFACE:${imgui_INCLUDE_DIR}>"
            "$<BUILD_INTERFACE:${imgui_BACKENDS_DIR}>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${imgui_RELATIVE_DEP_PATH}>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${imgui_RELATIVE_DEP_PATH}/backends>"
        )

        target_sources( ${new_imgui_target_name}
          INTERFACE
            ${im_${sys}_sources_b}
            ${im_${sys}_sources_i}
            ${im_${api}_sources_b}
            ${im_${api}_sources_i}
        )

        target_sources( ${new_imgui_target_name}
          INTERFACE
            FILE_SET HEADERS
              BASE_DIRS "${imgui_INCLUDE_DIR}"
              FILES
                ${im_${sys}_headers_b}
                ${im_${sys}_headers_i}
                ${im_${api}_headers_b}
                ${im_${api}_headers_i}
        )
      endif()
    endforeach()
  endforeach()
endfunction()

function( _configure_imgui_freetype_extension )
  if( NOT TARGET imgui_freetype_extension )
    set( imgui_FREETYPE_EXTENSION_DIR "${imgui_DEP_DIR}/misc/freetype" )
    set( extension_source_list
      "${imgui_FREETYPE_EXTENSION_DIR}/imgui_freetype.cpp"
    )

    set( extension_header_list
      "${imgui_FREETYPE_EXTENSION_DIR}/imgui_freetype.h"
    )

    gcmake_wrap_dep_files_in_generators( extension_source_list extension_sources_b extension_sources_i )
    gcmake_wrap_dep_files_in_generators( extension_header_list extension_headers_b extension_headers_i )

    add_library( imgui_freetype_extension INTERFACE )
    add_library( imgui::imgui_freetype_extension ALIAS imgui_freetype_extension )

    target_compile_definitions( imgui_freetype_extension
      INTERFACE
        "IMGUI_ENABLE_FREETYPE=1"
    )

    target_sources( imgui_freetype_extension
      INTERFACE
        ${extension_sources_b}
        ${extension_sources_i}
    )

    target_sources( imgui_freetype_extension
      INTERFACE
        FILE_SET HEADERS
          BASE_DIRS "${imgui_INCLUDE_DIR}"
          FILES ${extension_headers_b} ${extension_headers_i}
    )

    target_include_directories( imgui_freetype_extension
      SYSTEM
      INTERFACE
        "$<BUILD_INTERFACE:${imgui_FREETYPE_EXTENSION_DIR}>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${imgui_RELATIVE_DEP_PATH}/misc/freetype>"
    )
  endif()
endfunction()

function( _configure_imgui )
  set( core_source_list
    "${imgui_DEP_DIR}/imgui.cpp"
    "${imgui_DEP_DIR}/imgui_demo.cpp"
    "${imgui_DEP_DIR}/imgui_draw.cpp"
    "${imgui_DEP_DIR}/imgui_tables.cpp"
    "${imgui_DEP_DIR}/imgui_widgets.cpp"
  )

  set( core_header_list
    "${imgui_DEP_DIR}/imconfig.h"
    "${imgui_DEP_DIR}/imgui.h"
    "${imgui_DEP_DIR}/imgui_internal.h"
    "${imgui_DEP_DIR}/imgui_rectpack.h"
    "${imgui_DEP_DIR}/imgui_textedit.h"
    "${imgui_DEP_DIR}/imgui_truetype.h"
  )

  gcmake_wrap_dep_files_in_generators( core_source_list imgui_core_s_b imgui_core_s_i )
  gcmake_wrap_dep_files_in_generators( core_header_list imgui_core_h_b imgui_core_h_i )

  if( NOT TARGET imgui_core )
    add_library( imgui_core INTERFACE )
    add_library( imgui::imgui_core ALIAS imgui_core )

    target_include_directories( imgui_core
      SYSTEM
      INTERFACE
        "$<BUILD_INTERFACE:${imgui_INCLUDE_DIR}>"
        "$<BUILD_INTERFACE:${imgui_BACKENDS_DIR}>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${imgui_RELATIVE_DEP_PATH}>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${imgui_RELATIVE_DEP_PATH}/backends>"
    )

    target_sources( imgui_core
      INTERFACE
        ${imgui_core_s_b} ${imgui_core_s_i}
    )

    target_sources( imgui_core
      INTERFACE
        FILE_SET HEADERS
          BASE_DIRS "${imgui_INCLUDE_DIR}"
          FILES ${imgui_core_h_b} ${imgui_core_h_i}
    )
  endif()

  _configure_imgui_freetype_extension()
  _populate_imgui_backends()
endfunction()

_configure_imgui()
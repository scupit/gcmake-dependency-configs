
set( imgui_RELATIVE_DEP_PATH "dep/imgui" )
set( imgui_DEP_DIR "${TOPLEVEL_PROJECT_DIR}/${imgui_RELATIVE_DEP_PATH}" )
set( imgui_INCLUDE_DIR "${TOPLEVEL_PROJECT_DIR}/${imgui_RELATIVE_DEP_PATH}" )
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

    get_without_toplevel_dir_prefix( "${_imgui_${sys}_sources}" _imgui_${sys}_sources_install )
    get_without_toplevel_dir_prefix( "${_imgui_${sys}_headers}" _imgui_${sys}_headers_install )

    # im_<SYS>_sources_b
    # im_<SYS>_sources_i
    # im_<SYS>_headers_i
    # im_<SYS>_headers_b
    make_generators( "${_imgui_${sys}_sources}" "${_imgui_${sys}_sources_install}" im_${sys}_sources )
    make_generators( "${_imgui_${sys}_headers}" "${_imgui_${sys}_headers_install}" im_${sys}_headers )
  endforeach()

  foreach( api IN LISTS IMGUI_APIS )
    set( _imgui_${api}_sources "${imgui_BACKENDS_DIR}/imgui_impl_${api}.cpp" )
    set( _imgui_${api}_headers "${imgui_BACKENDS_DIR}/imgui_impl_${api}.h" )

    if( api STREQUAL "opengl3" )
      list( APPEND imgui_${api}_headers "${imgui_BACKENDS_DIR}/imgui_impl_opengl3_loader.h" )
    endif()

    get_without_toplevel_dir_prefix( "${_imgui_${api}_sources}" _imgui_${api}_sources_install )
    get_without_toplevel_dir_prefix( "${_imgui_${api}_headers}" _imgui_${api}_headers_install )

    # im_<API>_sources_b
    # im_<API>_sources_i
    # im_<API>_headers_i
    # im_<API>_headers_b
    make_generators( "${_imgui_${api}_sources}" "${_imgui_${api}_sources_install}" im_${api}_sources )
    make_generators( "${_imgui_${api}_headers}" "${_imgui_${api}_headers_install}" im_${api}_headers )
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

      add_library( ${new_imgui_target_name} INTERFACE )
      add_library( imgui::${sys}_${resolved_api_name} ALIAS ${new_imgui_target_name} )

      target_include_directories( ${new_imgui_target_name}
        INTERFACE
        "$<BUILD_INTERFACE:${imgui_INCLUDE_DIR}>"
        "$<BUILD_INTERFACE:${imgui_BACKENDS_DIR}>"
        "$<INSTALL_INTERFACE:include/${imgui_RELATIVE_DEP_PATH}>"
        "$<INSTALL_INTERFACE:include/${imgui_RELATIVE_DEP_PATH}/backends>"
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
            FILES
              ${im_${sys}_headers_b}
              ${im_${sys}_headers_i}
              ${im_${api}_headers_b}
              ${im_${api}_headers_i}
      )
    endforeach()
  endforeach()
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

  get_without_toplevel_dir_prefix( "${core_source_list}" imgui_sources_install )
  get_without_toplevel_dir_prefix( "${core_header_list}" imgui_headers_install )
  make_generators( "${core_source_list}" "${imgui_sources_install}" imgui_core_s )
  make_generators( "${core_header_list}" "${imgui_headers_install}" imgui_core_h )

  add_library( imgui_core INTERFACE )
  add_library( imgui::imgui_core ALIAS imgui_core )

  target_include_directories( imgui_core
    INTERFACE
      "$<BUILD_INTERFACE:${imgui_INCLUDE_DIR}>"
      "$<BUILD_INTERFACE:${imgui_BACKENDS_DIR}>"
      "$<INSTALL_INTERFACE:include/${imgui_RELATIVE_DEP_PATH}>"
      "$<INSTALL_INTERFACE:include/${imgui_RELATIVE_DEP_PATH}/backends>"
  )

  target_sources( imgui_core
    INTERFACE
      ${imgui_core_s_b} ${imgui_core_s_i}
  )

  target_sources( imgui_core
    INTERFACE
      FILE_SET HEADERS
        FILES ${imgui_core_h_b} ${imgui_core_h_i}
  )

  _populate_imgui_backends()
endfunction()

_configure_imgui()
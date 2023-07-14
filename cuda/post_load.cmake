
if( TARGET_SYSTEM_IS_WINDOWS AND NOT ALREADY_CONFIGURED_CUDA )
  message( "CUDA lib dir: ${CUDAToolkit_LIBRARY_DIR}")
  message( "CUDA lib root: ${CUDAToolkit_LIBRARY_ROOT}")
  message( "CUDA bin dir: ${CUDAToolkit_BIN_DIR}")

  file( GLOB CUDA_DLL_ABSOLUTE_PATHS "${CUDAToolkit_BIN_DIR}/*.dll" )
  set( CUDA_DLLS_TO_COPY )

  foreach( _cuda_dll_name IN ITEMS "cudart" )
    set( _cuda_paths_list ${CUDA_DLL_ABSOLUTE_PATHS} )
    list( FILTER _cuda_paths_list INCLUDE REGEX "/${_cuda_dll_name}[a-zA-Z0-9_]*\\.dll$")
    list( LENGTH _cuda_paths_list _cuda_paths_list_length )

    if( _cuda_paths_list_length GREATER 1 )
      message( FATAL_ERROR "${_cuda_paths_list_length} elements found which could be CUDA \"${_cuda_dll_name}\" dll. This list should be narrowed down to 1 item only.\nFound items:\n${_cuda_paths_list}" )
    elseif( _cuda_paths_list_length EQUAL 0)
      message( FATAL_ERROR "Failed to find a CUDA dll which matches the name \"${_cuda_dll_name}\" at path '${CUDAToolkit_BIN_DIR}'.")
    endif()

    list( GET _cuda_paths_list 0 _matching_cuda_dll )
    list( APPEND CUDA_DLLS_TO_COPY "${_matching_cuda_dll}" )
    if( DEFINED PROJECT_cuda_INSTALL_MODE )
      add_to_needed_bin_files_list( "${_matching_cuda_dll}" )
    endif()
  endforeach()

  if( NOT TARGET copy-cuda-dlls )
    add_custom_target( copy-cuda-dlls ALL
      COMMAND
        ${CMAKE_COMMAND} -E copy "$<JOIN:\"${CUDA_DLLS_TO_COPY}\",\" \">" "${MY_RUNTIME_OUTPUT_DIR}"
    )
  endif()

  set( ALREADY_CONFIGURED_CUDA TRUE )
endif()
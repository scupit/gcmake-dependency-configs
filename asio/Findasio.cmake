# Hints:
#   - ASIO_ROOT
#   - ASIO_NO_CMAKE

# Redo the search (by clearing the search cache results) if the given hints might result in
# a different library being found.
if( ASIO_ROOT )
  unset( ASIO_INCLUDE_DIR CACHE )
  set( _asio_search PATHS "${ASIO_ROOT}" NO_DEFAULT_PATH )
else()
  set( _asio_search )
endif()

find_package( Threads QUIET )

if( asio_FIND_REQUIRED AND NOT THREADS_FOUND )
  message( FATAL_ERROR "Failed to find ASIO because the system Threads library couldn't be found." )
endif()

if( NOT ASIO_NO_CMAKE )
  # vcpkg creates a cmake config file for asio.
  set( _INITIAL_CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} )

  if( EXISTS "$ENV{VCPKG_ROOT}" )
    list( PREPEND CMAKE_MODULE_PATH "$ENV{VCPKG_ROOT}/ports")
  endif()

  find_package( asio QUIET CONFIG
    ${_asio_search}
  )

  set( CMAKE_MODULE_PATH ${_INITIAL_CMAKE_MODULE_PATH} )
endif()

if( THREADS_FOUND AND NOT ASIO_FOUND )
  find_path( ASIO_INCLUDE_DIR
    NAMES "asio.hpp"
    ${_asio_search}
    PATH_SUFFIXES "include"
  )

  if( NOT TARGET asio::asio )
    add_library( asio::asio INTERFACE IMPORTED )

    if( USING_MINGW )
      target_link_libraries( asio::asio
        INTERFACE "ws2_32" "wsock32"
      )
    endif()

    target_include_directories( asio::asio
      INTERFACE "${ASIO_INCLUDE_DIR}"
    )
    target_compile_definitions( asio::asio
      INTERFACE "ASIO_STANDALONE"
    )
  endif()
endif()

include( FindPackageHandleStandardArgs )
find_package_handle_standard_args( asio
  REQUIRED_VARS ASIO_INCLUDE_DIR
)

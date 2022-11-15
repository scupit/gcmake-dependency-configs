# Input Hints:
#   - BROTLI_ROOT
#   - BROTLI_PREFER_STATIC
# 
# Targets:
#   - Brotli::brotlicommon
#   - Brotli::brotlienc
#   - Brotli::brotlidec
# 
# Defines:
#   - BROTLIENC_LIBRARY
#   - BROTLIDEC_LIBRARY
#   - BROTLICOMMON_LIBRARY
#   - BROTLI_LIBRARIES
#   - BROTLI_WINDOWS_SHARED_IMPORT_LIBRARIES

if( Brotli_FIND_COMPONENTS )
  message(AUTHOR_WARNING
    "Brotli does not provide any COMPONENTS.  Calling\n"
    "  find_package(Brotli COMPONENTS ...)\n"
    "will always fail."
  )
endif()

set( _ORIGINAL_FIND_LIBRARY_PREFIXES ${CMAKE_FIND_LIBRARY_PREFIXES} )
set( _ORIGINAL_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES} )

set( CMAKE_FIND_LIBRARY_PREFIXES )
set( CMAKE_FIND_LIBRARY_SUFFIXES )

set( _brotli_SEARCH_CONFIGS )

if( BROTLI_ROOT )
  set( _brotli_SEARCH_ROOT PATHS ${BROTLI_ROOT} NO_DEFAULT_PATH )
  list( APPEND _brotli_SEARCH_CONFIGS _brotli_SEARCH_ROOT )
endif()

set( _brotli_x86 "(x86)")
set( _brotli_SEARCH_NORMAL
  PATHS
    "$ENV{ProgramFiles}/brotli"
    "$ENV{ProgramFiles${_brotli_x86}}/brotli"
)
unset( _brotli_x86 )
list( APPEND _brotli_SEARCH_CONFIGS _brotli_SEARCH_NORMAL )

if( NOT "${_brotli_PREVIOUSLY_SEARCHED_FOR_STATIC}" STREQUAL "${BROTLI_PREFER_STATIC}" )
  set( _TYPE_SEARCHING_FOR_HAS_CHANGED TRUE )
else()
  set( _TYPE_SEARCHING_FOR_HAS_CHANGED FALSE )
endif()

set( _brotli_PREVIOUSLY_SEARCHED_FOR_STATIC ${BROTLI_PREFER_STATIC} CACHE INTERNAL "" FORCE )

# Redo the search (by clearing the search cache results) if the given hints might result in
# a different library being found.
if( BROTLI_ROOT OR _TYPE_SEARCHING_FOR_HAS_CHANGED )
  unset( BROTLI_LIBRARIES CACHE )
  unset( BROTLIENC_LIBRARY CACHE )
  unset( BROTLIDEC_LIBRARY CACHE )
  unset( BROTLICOMMON_LIBRARY CACHE )
  unset( BROTLI_INCLUDE_DIR CACHE )
endif()

set( _brotli_COMMON_NAMES brotlicommon )
set( _brotli_ENC_NAMES brotlienc )
set( _brotli_DEC_NAMES brotlidec )

if( BROTLI_PREFER_STATIC )
  list( PREPEND _brotli_COMMON_NAMES brotlicommon-static )
  list( PREPEND _brotli_ENC_NAMES brotlienc-static )
  list( PREPEND _brotli_DEC_NAMES brotlidec-static )
endif()

if( WIN32 )
  list( APPEND CMAKE_FIND_LIBRARY_PREFIXES "" "lib" )
  list( APPEND CMAKE_FIND_LIBRARY_SUFFIXES ".dll.a" )
endif()

if( BROTLI_PREFER_STATIC )
  if( WIN32 )
    list( PREPEND CMAKE_FIND_LIBRARY_SUFFIXES ".lib" ".a" )
  else()
    list( PREPEND CMAKE_FIND_LIBRARY_SUFFIXES ".a" )
  endif()
endif()

foreach( search IN LISTS _brotli_SEARCH_CONFIGS )
  find_path( BROTLI_INCLUDE_DIR
    NAMES
      "brotli/decode.h"
      "brotli/encode.h"
      "brotli/port.h"
      "brotli/shared_dictionary.h"
      "brotli/types.h"
    ${${search}}
    PATH_SUFFIXES "include"
  )

  find_library( BROTLICOMMON_LIBRARY
    NAMES ${_brotli_COMMON_NAMES}
    NAMES_PER_DIR
    ${${search}}
    PATH_SUFFIXES lib
  )

  find_library( BROTLIENC_LIBRARY
    NAMES ${_brotli_ENC_NAMES}
    NAMES_PER_DIR
    ${${search}}
    PATH_SUFFIXES lib
  )

  find_library( BROTLIDEC_LIBRARY
    NAMES ${_brotli_DEC_NAMES}
    NAMES_PER_DIR
    ${${search}}
    PATH_SUFFIXES lib
  )
endforeach()

include( FindPackageHandleStandardArgs )
find_package_handle_standard_args( Brotli
  REQUIRED_VARS
    BROTLI_INCLUDE_DIR
    BROTLICOMMON_LIBRARY
    BROTLIENC_LIBRARY
    BROTLIDEC_LIBRARY
  HANDLE_COMPONENTS
)

mark_as_advanced(
  BROTLICOMMON_LIBRARY
  BROTLIENC_LIBRARY
  BROTLIDEC_LIBRARY
)

if( BROTLI_FOUND )
  if( NOT BROTLI_LIBRARIES )
    set( BROTLI_LIBRARIES "${BROTLICOMMON_LIBRARY}" "${BROTLIENC_LIBRARY}" "${BROTLIDEC_LIBRARY}" )
  endif()

  set( BROTLI_WINDOWS_SHARED_IMPORT_LIBRARIES )

  foreach( _lib_item IN LISTS BROTLI_LIBRARIES )
    cmake_path( GET _lib_item FILENAME _brotli_lib_file_name )

    if( _brotli_lib_file_name MATCHES "dll" )
      list( APPEND BROTLI_WINDOWS_SHARED_IMPORT_LIBRARIES "${_lib_item}")
    endif()
  endforeach()

  if( NOT TARGET Brotli::brotlicommon )
    add_library( Brotli::brotlicommon UNKNOWN IMPORTED )

    target_include_directories( Brotli::brotlicommon
      INTERFACE "${BROTLI_INCLUDE_DIR}"
    )

    set_target_properties( Brotli::brotlicommon
      PROPERTIES
        IMPORTED_LOCATION "${BROTLICOMMON_LIBRARY}"
    )
  endif()

  if( NOT TARGET Brotli::brotlienc )
    add_library( Brotli::brotlienc UNKNOWN IMPORTED )

    target_include_directories( Brotli::brotlienc
      INTERFACE "${BROTLI_INCLUDE_DIR}"
    )

    set_target_properties( Brotli::brotlienc
      PROPERTIES
        IMPORTED_LOCATION "${BROTLIENC_LIBRARY}"
    )

    target_link_libraries( Brotli::brotlienc
      INTERFACE Brotli::brotlicommon
    )
  endif()

  if( NOT TARGET Brotli::brotlidec )
    add_library( Brotli::brotlidec UNKNOWN IMPORTED )

    target_include_directories( Brotli::brotlidec
      INTERFACE "${BROTLI_INCLUDE_DIR}"
    )

    set_target_properties( Brotli::brotlidec
      PROPERTIES
        IMPORTED_LOCATION "${BROTLIDEC_LIBRARY}"
    )

    target_link_libraries( Brotli::brotlidec
      INTERFACE Brotli::brotlicommon
    )
  endif()
endif()

set( CMAKE_FIND_LIBRARY_PREFIXES ${_ORIGINAL_FIND_LIBRARY_PREFIXES} )
set( CMAKE_FIND_LIBRARY_SUFFIXES ${_ORIGINAL_FIND_LIBRARY_SUFFIXES} )

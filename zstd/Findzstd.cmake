# Input Hints:
#   - zstd_ROOT
#   - zstd_NO_CMAKE
# 
# Targets:
#   - libzstd_shared
#   - libzstd_static
# 
# Defines:
#   - zstd_WINDOWS_SHARED_IMPORT_LIB
#   - zstd_PREFER_STATIC

if( zstd_FIND_COMPONENTS )
  message(AUTHOR_WARNING
    "zstd does not provide any COMPONENTS.  Calling\n"
    "  find_package(ZSTD COMPONENTS ...)\n"
    "will always fail."
    )
endif()

set( _ORIGINAL_FIND_LIBRARY_PREFIXES ${CMAKE_FIND_LIBRARY_PREFIXES} )
set( _ORIGINAL_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES} )

set( CMAKE_FIND_LIBRARY_PREFIXES )
set( CMAKE_FIND_LIBRARY_SUFFIXES )

set( _zstd_SEARCH_CONFIGS )

if( zstd_ROOT )
  set( _zstd_SEARCH_ROOT PATHS ${zstd_ROOT} NO_DEFAULT_PATH )
  list( APPEND _zstd_SEARCH_CONFIGS _zstd_SEARCH_ROOT )
endif()

set( _zstd_x86 "(x86)")
set( _zstd_SEARCH_NORMAL
  PATHS
    "$ENV{ProgramFiles}/zstd"
    "$ENV{ProgramFiles${_zstd_x86}}/zstd"
)
unset( _zstd_x86 )
list( APPEND _zstd_SEARCH_CONFIGS _zstd_SEARCH_NORMAL )

if( NOT "${_zstd_PREVIOUSLY_SEARCHED_FOR_STATIC}" STREQUAL "${zstd_PREFER_STATIC}" )
  set( _TYPE_SEARCHING_FOR_HAS_CHANGED TRUE )
else()
  set( _TYPE_SEARCHING_FOR_HAS_CHANGED FALSE )
endif()

set( _zstd_PREVIOUSLY_SEARCHED_FOR_STATIC ${zstd_PREFER_STATIC} CACHE INTERNAL "" FORCE )

# Redo the search (by clearing the search cache results) if the given hints might result in
# a different library being found.
if( zstd_ROOT OR _TYPE_SEARCHING_FOR_HAS_CHANGED )
  unset( _zstd_shared_import_lib CACHE )
  unset( zstd_LIBRARY CACHE )
  unset( zstd_INCLUDE_DIR CACHE )
  unset( zstd_DIR CACHE )
endif()

if( NOT zstd_NO_CMAKE )
  find_package( zstd CONFIG ${_zstd_SEARCH_ROOT} )
  if( zstd_FOUND )
    set( _zstd_CMAKE_CONFIG_FOUND TRUE )
  endif()
endif()

set( _zstd_LIB_NAMES zstd )

if( zstd_PREFER_STATIC )
  list( APPEND _zstd_LIB_NAMES zstd_static )
endif()

if( WIN32 )
  list( APPEND CMAKE_FIND_LIBRARY_PREFIXES "" "lib" )
  list( APPEND CMAKE_FIND_LIBRARY_SUFFIXES ".dll.a" )
endif()

if( zstd_PREFER_STATIC )
  if( WIN32 )
    list( PREPEND CMAKE_FIND_LIBRARY_SUFFIXES ".lib" ".a" )
  else()
    list( PREPEND CMAKE_FIND_LIBRARY_SUFFIXES ".a" )
  endif()
endif()

# _zstd_CMAKE_CONFIG_FOUND implies zstd_FOUND
if( _zstd_CMAKE_CONFIG_FOUND )
  if( NOT zstd_DIR )
    message( FATAL_ERROR "Error in Findzstd.cmake: find_package( zstd CONFIG ) found zstd, but didn't give a valid ")
  endif()

  if( NOT TARGET zstd::zstd )
    set( _targets_to_search zstd::libzstd_shared )

    if( zstd_PREFER_STATIC )
      list( PREPEND _targets_to_search zstd::libzstd_static )
    else()
      list( APPEND _targets_to_search zstd::libzstd_static )
    endif()

    foreach( target_searching_for IN LISTS _targets_to_search )
      if( TARGET ${target_searching_for} )
        add_library( zstd::zstd ALIAS ${target_searching_for} )

        if( "${target_searching_for}" MATCHES "shared" )
          find_library( _zstd_shared_import_lib
            NAMES ${_zstd_LIB_NAMES}
            PATHS "${zstd_DIR}/../.."
            # PATH_SUFFIXES lib
            NO_DEFAULT_PATH
          )

          set( zstd_WINDOWS_SHARED_IMPORT_LIB "${_zstd_shared_import_lib}" )
        endif()

        break()
      endif()
    endforeach()
  endif()
else()
  foreach( search IN LISTS _zstd_SEARCH_CONFIGS )
    find_path( zstd_INCLUDE_DIR
      NAMES zstd.h zdict.h zstd_errors.h
      ${${search}}
      PATH_SUFFIXES include
    )

    find_library( zstd_LIBRARY
      NAMES ${_zstd_LIB_NAMES}
      NAMES_PER_DIR
      ${${search}}
      PATH_SUFFIXES lib
    )
  endforeach()

  include( FindPackageHandleStandardArgs )
  find_package_handle_standard_args( zstd
    REQUIRED_VARS
      zstd_INCLUDE_DIR
      zstd_LIBRARY
    HANDLE_COMPONENTS
  )

  if( zstd_FOUND )
    cmake_path( GET zstd_LIBRARY FILENAME _zstd_lib_file_name )

    if( _zstd_lib_file_name MATCHES "dll" )
      set( zstd_WINDOWS_SHARED_IMPORT_LIB "${zstd_LIBRARY}" )
    endif()

    add_library( zstd::zstd UNKNOWN IMPORTED )
    target_include_directories( zstd::zstd
      INTERFACE "${zstd_INCLUDE_DIR}"
    )
  
    set_target_properties( zstd::zstd
      PROPERTIES
        IMPORTED_LOCATION "${zstd_LIBRARY}"
    )
  endif()
endif()

set( CMAKE_FIND_LIBRARY_PREFIXES ${_ORIGINAL_FIND_LIBRARY_PREFIXES} )
set( CMAKE_FIND_LIBRARY_SUFFIXES ${_ORIGINAL_FIND_LIBRARY_SUFFIXES} )

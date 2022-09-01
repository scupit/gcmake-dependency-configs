# SFML force-overrides the doc string for CMAKE_BUILD_TYPE and BUILD_SHARED_LIBS.
# This force-overrides the doc strings back.
if( NOT ${isMultiConfigGenerator} )
  set( CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING "${LOCAL_CMAKE_BUILD_TYPE_DOC_STRING}" FORCE )
endif()

if( DEFINED BUILD_SHARED_LIBS )
  set( BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS} CACHE BOOL "${LOCAL_BUILD_SHARED_LIBS_DOC_STRING}" FORCE )
endif()
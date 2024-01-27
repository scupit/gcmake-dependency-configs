
# These variables are written per root project by GCMake.
# If a project specifies a cpp language verison, one of these is guaranteed
# to exist at this point.
if( DEFINED PROJECT_CXX_LANGUAGE_MINIMUM_STANDARD )
  set( _current_cpp_version ${PROJECT_CXX_LANGUAGE_MINIMUM_STANDARD} )
elseif( DEFINED PROJECT_CXX_LANGUAGE_EXACT_STANDARD )
  set( _current_cpp_version ${PROJECT_CXX_LANGUAGE_EXACT_STANDARD} )
endif()

if( DEFINED _current_cpp_version )
  if( _current_cpp_version EQUAL 23 OR _current_cpp_version EQUAL 26 )
    option( GLM_ENABLE_CXX_20 "Enable GLM C++20 features. Set to ON by GCMake" ON )
  endif()

  foreach( _standard IN ITEMS 20 17 14 11 98)
    if( _current_cpp_version EQUAL _standard )
      option( GLM_ENABLE_CXX_${_standard} "Enable GLM C++${_standard} features. Set to ON by GCMake" ON )
      break()
    endif()
  endforeach()
endif()

option( GLM_BUILD_TESTS "Whether to build GLM tests. GCMake sets this to OFF by default." OFF )

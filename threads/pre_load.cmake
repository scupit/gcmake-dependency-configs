set( _threads_message "Set to TRUE to use pthread instead of other threading libraries, if possible" )

if( TARGET_SYSTEM_IS_WINDOWS )
  set( THREADS_PREFER_PTHREAD_FLAG FALSE CACHE BOOL "${_threads_message}" )
else()
  set( THREADS_PREFER_PTHREAD_FLAG TRUE CACHE BOOL "${_threads_message}" )
endif()

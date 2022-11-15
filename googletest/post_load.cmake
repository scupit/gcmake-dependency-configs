set( _gtest_target_list )

# If GoogleTest is used, then at least one of these targets is guaranteed to exist.
foreach( _target_name IN ITEMS gmock gmock_main gtest gtest_main )
  if( TARGET ${_target_name} )
    list( APPEND _gtest_target_list ${_target_name} )
  endif()
endforeach()

# GoogleTest hardcodes the output directories for its library targets.
# This ensures they are built into the expected binary directory.
set_target_properties( ${_gtest_target_list}
  PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${MY_RUNTIME_OUTPUT_DIR}"
    PDB_OUTPUT_DIRECTORY "${MY_RUNTIME_OUTPUT_DIR}"
    COMPILE_PDB_OUTPUT_DIRECTORY "${MY_LIBRARY_OUTPUT_DIR}"
    LIBRARY_OUTPUT_DIRECTORY "${MY_LIBRARY_OUTPUT_DIR}"
    ARCHIVE_OUTPUT_DIRECTORY "${MY_LIBRARY_OUTPUT_DIR}"
)
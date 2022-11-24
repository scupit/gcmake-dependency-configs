gcmake_unaliased_target_name( yaml-cpp::yaml-cpp yaml_target_name )
get_target_property( YAML_CPP_LIB_TYPE ${yaml_target_name} TYPE )

if( YAML_CPP_LIB_TYPE STREQUAL "STATIC_LIBRARY" )
  # This define is added using add_definitions(...) in yaml-cpp CMakeLists.txt when
  # building the static version of the library. However, it is somehow lost along the way
  # when being used as a subdirectory dependency. This is a quick fix for that.
  target_compile_definitions( yaml-cpp
    INTERFACE
      -DYAML_CPP_STATIC_DEFINE
  )
endif()
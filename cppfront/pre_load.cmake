set( CPPFRONT_ROOT "" CACHE PATH "An alternative directory to search for CppFront" )

if( CMAKE_CROSSCOMPILING )
  set( _embed_cppfront_default_value OFF )
else()
  set( _embed_cppfront_default_value ON )
endif()

option( EMBED_CPPFRONT
  "When set to ON, cppfront is cloned and built before the project. Otherwise, an existing installation is searched for using find_package. Defaults to OFF when cross-compiling, and ON otherwise."
  # It's still possible to run this when CMAKE_CROSSCOMPILING_EMULATOR is defined,
  # but Emscripten requires some extra work when writing files (which isn't clear upfront). As a result,
  # leave turning this on when cross-compiling to users who know the consequences.
  ${_embed_cppfront_default_value}
)

if( USING_EMSCRIPTEN AND EMBED_CPPFRONT )
  message( FATAL_ERROR "Embedding CppFront in the build while using EMSCRIPTEN is not allowed. Emscripten requires special consideration before its JS outputs are able to actually write physical files. Please set EMBED_CPPFRONT OFF to use a cppfront installation on your system.\nSee https://github.com/scupit/gcmake-dependency-configs/tree/develop/cppfront#installing-cppfront-on-your-system for more details." )
endif()
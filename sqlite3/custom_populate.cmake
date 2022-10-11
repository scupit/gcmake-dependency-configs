
set( sqlite3_RELATIVE_DEP_PATH "dep/sqlite3" )
set( sqlite3_DEP_DIR "${TOPLEVEL_PROJECT_DIR}/${sqlite3_RELATIVE_DEP_PATH}" )
set( sqlite3_INCLUDE_DIR "${TOPLEVEL_PROJECT_DIR}/${sqlite3_RELATIVE_DEP_PATH}" )
option( sqlite3_BUILD_SHELL "If ON, build the sqlite shell executable." OFF )

# In this 'dependency configuration' context, the current source directory and the toplevel
# source directory are always the same. This is because dependencies are only configured in the project root.
# However, we'll use the toplevel project dir variables for clarity.

function( _populate_sqlite3 )
  # The sqlite amalgamation has 4 files:
  #   - shell.c: Implements the sqlite shell
  #   - sqlite3.c
  #   - sqlite3.h
  #   - sqlite3ext.h: Header for programs which intend to be imported by sqlite as sqlite extensions.
  #                   I'm going to ignore this for now.

  if( NOT TARGET sqlite3 )
    # Since a library type is not specified, whether 'sqlite3' is built as static or shared
    # depends on the value of BUILD_SHARED_LIBS.
    add_library( sqlite3 )
    add_library( sqlite3::sqlite3 ALIAS sqlite3 )

    set( sqlite3_sources "${sqlite3_DEP_DIR}/sqlite3.c" )
    set( sqlite3_headers "${sqlite3_DEP_DIR}/sqlite3.h" )

    get_without_toplevel_dir_prefix( "${sqlite3_sources}" sqlite3_sources_install )
    make_generators( "${sqlite3_sources}" "${sqlite3_sources_install}" sqlite_s )

    get_without_toplevel_dir_prefix( "${sqlite3_headers}" sqlite3_headers_install )
    make_generators( "${sqlite3_headers}" "${sqlite3_headers_install}" sqlite_h )

    target_sources( sqlite3
      PRIVATE
        ${sqlite_s_b}
    )

    target_sources( sqlite3
      PUBLIC
        ${sqlite_h_b}
        ${sqlite_h_i}
    )

    target_include_directories( sqlite3
      PUBLIC
        "$<BUILD_INTERFACE:${sqlite3_INCLUDE_DIR}>"
        "$<INSTALL_INTERFACE:include/${sqlite3_RELATIVE_DEP_PATH}>"
    )
  endif()

  if( sqlite3_BUILD_SHELL AND NOT TARGET sqlite )
    set( sqlite_shell_sources "${sqlite3_DEP_DIR}/sqlite3.c" )

    get_without_toplevel_dir_prefix( "${sqlite_shell_sources}" sqlite_shell_sources_install )
    make_generators( "${sqlite_shell_sources}" "${sqlite3_sources_install}" sqlite_shell_s )

    add_executable( sqlite )

    target_sources( sqlite
      PRIVATE 
        ${sqlite_shell_s_b}
    )

    target_link_libraries( sqlite PRIVATE sqlite3::sqlite3 )
  endif()
endfunction()

_populate_sqlite3()
# Set to ON by default since GCMake exposes targets for both static and shared libs.
# Also, the shared version of the library is only built when BUILD_SHARED_LIBS is ON. Keep that in
# mind.
option(PUGIXML_BUILD_SHARED_AND_STATIC_LIBS "Build both shared and static libraries" ON )

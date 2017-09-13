function (write_static_version_header hash)
  set(VERSIONTAG "${hash}")
  configure_file("src/version.cpp.in" "version.cpp")
endfunction ()

find_package(Git QUIET)
if ("$Format:$" STREQUAL "")
  # We're in a tarball; use hard-coded variables.
  write_static_version_header("release")
elseif (GIT_FOUND OR Git_FOUND)
  message(STATUS "Found Git: ${GIT_EXECUTABLE}")
  add_custom_command(
    OUTPUT            "${CMAKE_BINARY_DIR}/version.cpp"
                      "${CMAKE_BINARY_DIR}/.version-dummy-output"  # dummy output to force this command to always run
    COMMAND           "${CMAKE_COMMAND}"
                      "-D" "GIT=${GIT_EXECUTABLE}"
                      "-D" "TO=${CMAKE_BINARY_DIR}/version.cpp"
                      "-P" "src/version.cmake"
    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
else()
  message(STATUS "WARNING: Git was not found!")
  write_static_version_header("unknown")
endif ()

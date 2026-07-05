# Make imported dependency targets from vcpkg visible to downstream CMake packages.
# This is used by the Windows ARM64 CI workflow to satisfy Qt/libtorrent/qBittorrent
# package-config dependencies that otherwise fail with "target was not found".

find_package(ZLIB REQUIRED)
if(TARGET ZLIB::ZLIB)
  set_property(TARGET ZLIB::ZLIB PROPERTY IMPORTED_GLOBAL TRUE)
endif()

find_package(OpenSSL REQUIRED)
foreach(_target IN ITEMS OpenSSL::SSL OpenSSL::Crypto)
  if(TARGET ${_target})
    set_property(TARGET ${_target} PROPERTY IMPORTED_GLOBAL TRUE)
  endif()
endforeach()

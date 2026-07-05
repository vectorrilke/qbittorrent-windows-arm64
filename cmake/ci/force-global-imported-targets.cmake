# Ensure imported dependency targets from vcpkg are visible to downstream packages
# during the qBittorrent configure step.

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

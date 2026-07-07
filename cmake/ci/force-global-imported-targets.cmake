# Ensure dependency imported targets are globally visible before project() so
# package configs (notably libtorrent and Qt wrappers) can link to them.
set(CMAKE_FIND_PACKAGE_TARGETS_GLOBAL TRUE)

if(NOT DEFINED OPENSSL_USE_STATIC_LIBS)
  set(OPENSSL_USE_STATIC_LIBS TRUE)
endif()

find_package(OpenSSL REQUIRED)
find_package(ZLIB REQUIRED)

if(NOT TARGET OpenSSL::SSL OR NOT TARGET OpenSSL::Crypto)
  message(FATAL_ERROR "OpenSSL imported targets are missing after find_package(OpenSSL REQUIRED)")
endif()

if(NOT TARGET ZLIB::ZLIB)
  message(FATAL_ERROR "ZLIB::ZLIB target is missing after find_package(ZLIB REQUIRED)")
endif()

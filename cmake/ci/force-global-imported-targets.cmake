# Create the imported dependency targets explicitly so downstream CMake packages
# can resolve OpenSSL/ZLIB link interfaces during the Windows ARM64 CI build.

set(_ci_zlib_root "$ENV{ZLIB_ROOT}")
if(NOT _ci_zlib_root)
  set(_ci_zlib_root "$ENV{VCPKG_ROOT}/installed/arm64-windows-static-release")
endif()

if(NOT TARGET ZLIB::ZLIB)
  add_library(ZLIB::ZLIB STATIC IMPORTED GLOBAL)
  set_target_properties(ZLIB::ZLIB PROPERTIES
    IMPORTED_LOCATION "${_ci_zlib_root}/lib/zlib.lib"
    INTERFACE_INCLUDE_DIRECTORIES "${_ci_zlib_root}/include"
  )
endif()

if(NOT TARGET OpenSSL::SSL)
  add_library(OpenSSL::SSL STATIC IMPORTED GLOBAL)
  set_target_properties(OpenSSL::SSL PROPERTIES
    IMPORTED_LOCATION "${OPENSSL_SSL_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${OPENSSL_INCLUDE_DIR}"
  )
endif()

if(NOT TARGET OpenSSL::Crypto)
  add_library(OpenSSL::Crypto STATIC IMPORTED GLOBAL)
  set_target_properties(OpenSSL::Crypto PROPERTIES
    IMPORTED_LOCATION "${OPENSSL_CRYPTO_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${OPENSSL_INCLUDE_DIR}"
  )
endif()

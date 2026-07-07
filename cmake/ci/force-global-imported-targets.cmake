# Create the imported dependency targets explicitly so downstream CMake packages
# can resolve OpenSSL/ZLIB link interfaces during the Windows ARM64 CI build.

set(_ci_zlib_root "$ENV{ZLIB_ROOT}")
if(NOT _ci_zlib_root)
  set(_ci_zlib_root "${ZLIB_ROOT}")
endif()
if(NOT _ci_zlib_root)
  set(_ci_zlib_root "$ENV{VCPKG_ROOT}/installed/arm64-windows-static-release")
endif()

# Normalize any backslashes from environment paths to avoid CMake escape parsing issues.
string(REPLACE "\\" "/" _ci_zlib_root "${_ci_zlib_root}")

set(_ci_zlib_lib "${_ci_zlib_root}/lib/zlib.lib")
if(NOT EXISTS "${_ci_zlib_lib}")
  set(_ci_zlib_lib "${_ci_zlib_root}/lib/libzlib.lib")
endif()
if(NOT EXISTS "${_ci_zlib_lib}")
  set(_ci_zlib_lib "${_ci_zlib_root}/lib/zlibstatic.lib")
endif()
if(NOT EXISTS "${_ci_zlib_lib}")
  set(_ci_zlib_lib "${_ci_zlib_root}/lib/zlibd.lib")
endif()
if(NOT EXISTS "${_ci_zlib_lib}")
  set(_ci_zlib_lib "${_ci_zlib_root}/lib/zlibstaticd.lib")
endif()
if(NOT EXISTS "${_ci_zlib_lib}")
  set(_ci_zlib_lib "${_ci_zlib_root}/lib/libzlibd.lib")
endif()

# Prefer explicit values injected from the workflow invocation when present.
if(ZLIB_LIBRARY AND EXISTS "${ZLIB_LIBRARY}")
  set(_ci_zlib_lib "${ZLIB_LIBRARY}")
elseif(ZLIB_LIBRARY_RELEASE AND EXISTS "${ZLIB_LIBRARY_RELEASE}")
  set(_ci_zlib_lib "${ZLIB_LIBRARY_RELEASE}")
elseif(ZLIB_LIBRARY_DEBUG AND EXISTS "${ZLIB_LIBRARY_DEBUG}")
  set(_ci_zlib_lib "${ZLIB_LIBRARY_DEBUG}")
endif()

if(NOT EXISTS "${_ci_zlib_lib}")
  file(GLOB _ci_zlib_candidates
    "${_ci_zlib_root}/lib/*zlib*.lib"
    "${_ci_zlib_root}/lib/*z*.lib"
  )
  list(LENGTH _ci_zlib_candidates _ci_zlib_candidate_count)
  if(_ci_zlib_candidate_count GREATER 0)
    list(GET _ci_zlib_candidates 0 _ci_zlib_lib)
  endif()
endif()

if(NOT TARGET ZLIB::ZLIB AND EXISTS "${_ci_zlib_lib}")
  add_library(ZLIB::ZLIB STATIC IMPORTED GLOBAL)
  set_target_properties(ZLIB::ZLIB PROPERTIES
    IMPORTED_LOCATION "${_ci_zlib_lib}"
    INTERFACE_INCLUDE_DIRECTORIES "${_ci_zlib_root}/include"
  )
elseif(NOT TARGET ZLIB::ZLIB)
  message(STATUS "CI helper did not bootstrap ZLIB::ZLIB; no compatible library file found under ${_ci_zlib_root}/lib")
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

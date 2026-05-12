cmake_minimum_required(VERSION 3.16...4.2.3)

project(muduo LANGUAGES C CXX)

if(NOT CMAKE_SYSTEM_NAME STREQUAL "Linux")
  message(FATAL_ERROR "muduo is configured for Linux-only builds")
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(GNUInstallDirs)
include(MuduoBuild)

muduo_set_default_build_type()

if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
  set(MUDUO_DEFAULT_BUILD_EXAMPLES ON)
else()
  set(MUDUO_DEFAULT_BUILD_EXAMPLES OFF)
endif()
option(MUDUO_BUILD_EXAMPLES "Build Muduo examples and tests" ${MUDUO_DEFAULT_BUILD_EXAMPLES})
option(MUDUO_ENABLE_PROTOBUF "Build protobuf-based libraries and examples when a compatible protobuf is available" ON)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/lib")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")

find_package(Threads REQUIRED)
find_package(Boost REQUIRED)
find_package(PkgConfig)
find_package(Protobuf)
find_package(CURL)
find_package(ZLIB)

find_path(CARES_INCLUDE_DIR ares.h)
find_library(CARES_LIBRARY NAMES cares)
find_path(MHD_INCLUDE_DIR microhttpd.h)
find_library(MHD_LIBRARY NAMES microhttpd)
find_library(BOOSTTEST_LIBRARY NAMES boost_unit_test_framework)
find_library(BOOSTPO_LIBRARY NAMES boost_program_options)
find_library(BOOSTSYSTEM_LIBRARY NAMES boost_system)
find_path(TCMALLOC_INCLUDE_DIR gperftools/heap-profiler.h)
find_library(TCMALLOC_LIBRARY NAMES tcmalloc_and_profiler)
find_path(HIREDIS_INCLUDE_DIR hiredis/hiredis.h)
find_library(HIREDIS_LIBRARY NAMES hiredis)
find_path(GD_INCLUDE_DIR gd.h)
find_library(GD_LIBRARY NAMES gd)
find_program(THRIFT_COMPILER thrift)
find_path(THRIFT_INCLUDE_DIR thrift)
find_library(THRIFT_LIBRARY NAMES thrift)

add_library(muduo_public_config INTERFACE)
target_compile_features(muduo_public_config INTERFACE cxx_std_11)
target_compile_definitions(muduo_public_config
  INTERFACE
    CHECK_PTHREAD_RETURN_VALUE
    _FILE_OFFSET_BITS=64)
target_include_directories(muduo_public_config
  INTERFACE
    "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>"
    "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>")
target_link_libraries(muduo_public_config INTERFACE Boost::boost)

add_library(muduo_private_options INTERFACE)
target_compile_options(muduo_private_options
  INTERFACE
    -g
    -Wall
    -Wextra
    -Werror
    -Wconversion
    -Wno-unused-parameter
    -Wold-style-cast
    -Woverloaded-virtual
    -Wpointer-arith
    -Wshadow
    -Wwrite-strings
    -march=native
    "$<$<CXX_COMPILER_ID:Clang>:-Wno-null-dereference>"
    "$<$<CXX_COMPILER_ID:Clang>:-Wno-sign-conversion>"
    "$<$<CXX_COMPILER_ID:Clang>:-Wno-unused-local-typedef>"
    "$<$<CXX_COMPILER_ID:Clang>:-Wthread-safety>"
    "$<$<STREQUAL:${CMAKE_BUILD_BITS},32>:-m32>")
target_link_options(muduo_private_options
  INTERFACE
    "$<$<NOT:$<CXX_COMPILER_ID:Clang>>:-rdynamic>"
    "$<$<STREQUAL:${CMAKE_BUILD_BITS},32>:-m32>")
target_compile_options(muduo_private_options
  INTERFACE
    "$<$<CONFIG:Debug>:-O0>"
    "$<$<CONFIG:Release>:-O2>")
target_compile_definitions(muduo_private_options
  INTERFACE
    "$<$<CONFIG:Release>:NDEBUG>")

muduo_create_library_dependency(muduo::cares CARES_INCLUDE_DIR CARES_LIBRARY)
muduo_create_library_dependency(muduo::microhttpd MHD_INCLUDE_DIR MHD_LIBRARY)
muduo_create_library_dependency(muduo::tcmalloc TCMALLOC_INCLUDE_DIR TCMALLOC_LIBRARY)
muduo_create_library_dependency(muduo::hiredis HIREDIS_INCLUDE_DIR HIREDIS_LIBRARY)
muduo_create_library_dependency(muduo::gd GD_INCLUDE_DIR GD_LIBRARY)
muduo_create_library_dependency(muduo::thrift THRIFT_INCLUDE_DIR THRIFT_LIBRARY)
muduo_create_link_dependency(muduo::boost_unit_test_framework BOOSTTEST_LIBRARY)
muduo_create_link_dependency(muduo::boost_program_options BOOSTPO_LIBRARY)
muduo_create_link_dependency(muduo::boost_system BOOSTSYSTEM_LIBRARY)

if(PROTOBUF_FOUND)
  set(MUDUO_PROTOBUF_LIBRARIES ${Protobuf_LIBRARIES})
  set(MUDUO_PROTOC ${Protobuf_PROTOC_EXECUTABLE})
  if(PkgConfig_FOUND)
    pkg_check_modules(MUDUO_PROTOBUF_PC QUIET IMPORTED_TARGET protobuf)
  endif()
  if(TARGET protobuf::libprotobuf)
    set(MUDUO_PROTOBUF_LIBRARIES protobuf::libprotobuf)
  endif()
  if(TARGET protobuf::protoc)
    set(MUDUO_PROTOC protobuf::protoc)
  endif()
endif()

if(PROTOBUF_FOUND AND NOT TARGET muduo::protobuf)
  add_library(muduo::protobuf INTERFACE IMPORTED GLOBAL)
  if(TARGET PkgConfig::MUDUO_PROTOBUF_PC)
    target_link_libraries(muduo::protobuf INTERFACE PkgConfig::MUDUO_PROTOBUF_PC)
  else()
    target_link_libraries(muduo::protobuf INTERFACE ${MUDUO_PROTOBUF_LIBRARIES})
  endif()
endif()

set(MUDUO_PROTOBUF_FOUND FALSE)
if(MUDUO_ENABLE_PROTOBUF
   AND PROTOBUF_FOUND
   AND ZLIB_FOUND
   AND MUDUO_PROTOC)
  set(MUDUO_PROTOBUF_FOUND TRUE)
endif()

if(MUDUO_ENABLE_PROTOBUF AND PROTOBUF_FOUND AND NOT MUDUO_PROTOBUF_FOUND)
  message(STATUS "protobuf support disabled: libprotobuf, protoc, or zlib was not found")
endif()

if(CURL_FOUND)
  message(STATUS "found curl")
endif()
if(MUDUO_PROTOBUF_FOUND)
  message(STATUS "found protobuf")
endif()
if(ZLIB_FOUND)
  message(STATUS "found zlib")
endif()
if(TARGET muduo::cares)
  message(STATUS "found cares")
endif()
if(TARGET muduo::tcmalloc)
  message(STATUS "found tcmalloc")
endif()
if(TARGET muduo::hiredis)
  message(STATUS "found hiredis")
endif()
if(TARGET muduo::gd)
  message(STATUS "found gd")
endif()
if(THRIFT_COMPILER AND TARGET muduo::thrift)
  message(STATUS "found thrift")
endif()

enable_testing()

add_subdirectory(muduo/base)
add_subdirectory(muduo/net)

if(MUDUO_BUILD_EXAMPLES)
  add_subdirectory(contrib)
  add_subdirectory(examples)
elseif(TARGET muduo::cares)
  add_subdirectory(examples/cdns)
endif()

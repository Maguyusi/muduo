set(MUDUO_THRIFT_SRCS
    ThriftConnection.cc
    ThriftServer.cc
    )
muduo_add_library(muduo_thrift ${MUDUO_THRIFT_SRCS})
target_include_directories(muduo_thrift
  PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>"
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>")
target_link_libraries(muduo_thrift
  PUBLIC
    muduo_net
    muduo::thrift)

if(THRIFT_COMPILER AND TARGET muduo::thrift)
  add_subdirectory(tests)
endif()

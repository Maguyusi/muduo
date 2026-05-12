muduo_protobuf_generate_cpp(RPC_PROTO_SRC RPC_PROTO_HDR rpc.proto)
muduo_target_generated_protobuf_source("${RPC_PROTO_SRC}")

muduo_add_library(muduo_protorpc_wire
  "${RPC_PROTO_SRC}"
  RpcCodec.cc)
muduo_target_uses_protobuf(muduo_protorpc_wire)
muduo_target_no_shadow_error(muduo_protorpc_wire)
target_include_directories(muduo_protorpc_wire
  PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_BINARY_DIR}>"
    "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/muduo/net/protorpc>")
target_link_libraries(muduo_protorpc_wire
  PUBLIC
    muduo_protobuf_codec
    muduo::protobuf)

if(MUDUO_BUILD_EXAMPLES)
  muduo_add_executable(protobuf_rpc_wire_test RpcCodec_test.cc)
  muduo_target_uses_protobuf(protobuf_rpc_wire_test)
  muduo_target_no_shadow_error(protobuf_rpc_wire_test)
  target_link_libraries(protobuf_rpc_wire_test
    PRIVATE
      muduo_protorpc_wire
      muduo_protobuf_codec)
endif()

muduo_add_library(muduo_protorpc
  RpcChannel.cc
  RpcServer.cc)
muduo_target_uses_protobuf(muduo_protorpc)
muduo_target_no_shadow_error(muduo_protorpc)
target_link_libraries(muduo_protorpc
  PUBLIC
    muduo_protorpc_wire
    muduo_protobuf_codec
    muduo_net
    muduo::protobuf
  PRIVATE
    ZLIB::ZLIB)

if(TARGET muduo::tcmalloc)
  target_link_libraries(muduo_protorpc PRIVATE muduo::tcmalloc)
endif()

muduo_install_library(muduo_protorpc_wire)
muduo_install_library(muduo_protorpc)

set(HEADERS
  RpcCodec.h
  RpcChannel.h
  RpcServer.h
  rpc.proto
  rpcservice.proto
  "${RPC_PROTO_HDR}"
  )
install(FILES ${HEADERS} DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/muduo/net/protorpc")

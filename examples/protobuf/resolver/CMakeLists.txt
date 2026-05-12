muduo_protobuf_generate_cpp(RESOLVER_PROTO_SRC RESOLVER_PROTO_HDR resolver.proto)
muduo_target_generated_protobuf_source("${RESOLVER_PROTO_SRC}")

muduo_add_library(resolver_proto "${RESOLVER_PROTO_SRC}")
muduo_target_uses_protobuf(resolver_proto)
target_include_directories(resolver_proto PUBLIC "${PROJECT_BINARY_DIR}")
target_link_libraries(resolver_proto
  PUBLIC
    muduo::protobuf
    Threads::Threads)

muduo_add_executable(protobuf_rpc_resolver_client client.cc)
muduo_target_uses_protobuf(protobuf_rpc_resolver_client)
muduo_target_no_shadow_error(protobuf_rpc_resolver_client)
target_link_libraries(protobuf_rpc_resolver_client
  PRIVATE
    resolver_proto
    muduo_protorpc)

muduo_add_executable(protobuf_rpc_resolver_server server.cc)
muduo_target_uses_protobuf(protobuf_rpc_resolver_server)
muduo_target_no_shadow_error(protobuf_rpc_resolver_server)
target_link_libraries(protobuf_rpc_resolver_server
  PRIVATE
    resolver_proto
    muduo_protorpc
    muduo_cdns)

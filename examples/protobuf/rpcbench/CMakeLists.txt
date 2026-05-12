muduo_protobuf_generate_cpp(ECHO_PROTO_SRC ECHO_PROTO_HDR echo.proto)
muduo_target_generated_protobuf_source("${ECHO_PROTO_SRC}")

muduo_add_library(echo_proto "${ECHO_PROTO_SRC}")
muduo_target_uses_protobuf(echo_proto)
target_include_directories(echo_proto PUBLIC "${PROJECT_BINARY_DIR}")
target_link_libraries(echo_proto
  PUBLIC
    muduo::protobuf
    Threads::Threads)

muduo_add_executable(protobuf_rpc_echo_client client.cc)
muduo_target_uses_protobuf(protobuf_rpc_echo_client)
muduo_target_no_shadow_error(protobuf_rpc_echo_client)
target_link_libraries(protobuf_rpc_echo_client
  PRIVATE
    echo_proto
    muduo_protorpc)

muduo_add_executable(protobuf_rpc_echo_server server.cc)
muduo_target_uses_protobuf(protobuf_rpc_echo_server)
muduo_target_no_shadow_error(protobuf_rpc_echo_server)
target_link_libraries(protobuf_rpc_echo_server
  PRIVATE
    echo_proto
    muduo_protorpc)

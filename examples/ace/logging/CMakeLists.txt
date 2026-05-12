muduo_protobuf_generate_cpp(LOGRECORD_PROTO_SRC LOGRECORD_PROTO_HDR logrecord.proto)
muduo_target_generated_protobuf_source("${LOGRECORD_PROTO_SRC}")

muduo_add_library(ace_logging_proto "${LOGRECORD_PROTO_SRC}")
muduo_target_uses_protobuf(ace_logging_proto)
target_include_directories(ace_logging_proto PUBLIC "${PROJECT_BINARY_DIR}")
target_link_libraries(ace_logging_proto
  PUBLIC
    muduo::protobuf
    Threads::Threads)

muduo_add_executable(ace_logging_client client.cc)
muduo_target_uses_protobuf(ace_logging_client)
muduo_target_no_shadow_error(ace_logging_client)
target_link_libraries(ace_logging_client
  PRIVATE
    muduo_protobuf_codec
    ace_logging_proto)

muduo_add_executable(ace_logging_server server.cc)
muduo_target_uses_protobuf(ace_logging_server)
muduo_target_no_shadow_error(ace_logging_server)
target_link_libraries(ace_logging_server
  PRIVATE
    muduo_protobuf_codec
    ace_logging_proto)

muduo_add_library(protobuf_codec codec.cc)
muduo_target_uses_protobuf(protobuf_codec)
target_link_libraries(protobuf_codec
  PUBLIC
    muduo_net
    muduo::protobuf
  PRIVATE
    ZLIB::ZLIB)

muduo_protobuf_generate_cpp(QUERY_PROTO_SRC QUERY_PROTO_HDR query.proto)
muduo_target_generated_protobuf_source("${QUERY_PROTO_SRC}")

muduo_add_library(query_proto "${QUERY_PROTO_SRC}")
muduo_target_uses_protobuf(query_proto)
target_include_directories(query_proto PUBLIC "${PROJECT_BINARY_DIR}")
target_link_libraries(query_proto
  PUBLIC
    muduo::protobuf
    Threads::Threads)

muduo_add_executable(protobuf_codec_test codec_test.cc)
muduo_target_uses_protobuf(protobuf_codec_test)
muduo_target_no_shadow_error(protobuf_codec_test)
target_link_libraries(protobuf_codec_test
  PRIVATE
    protobuf_codec
    query_proto)

muduo_add_executable(protobuf_dispatcher_lite_test dispatcher_lite_test.cc)
muduo_target_uses_protobuf(protobuf_dispatcher_lite_test)
muduo_target_no_shadow_error(protobuf_dispatcher_lite_test)
target_link_libraries(protobuf_dispatcher_lite_test PRIVATE query_proto)

muduo_add_executable(protobuf_dispatcher_test dispatcher_test.cc)
muduo_target_uses_protobuf(protobuf_dispatcher_test)
muduo_target_no_shadow_error(protobuf_dispatcher_test)
target_link_libraries(protobuf_dispatcher_test PRIVATE query_proto)

muduo_add_executable(protobuf_server server.cc)
muduo_target_uses_protobuf(protobuf_server)
muduo_target_no_shadow_error(protobuf_server)
target_link_libraries(protobuf_server
  PRIVATE
    protobuf_codec
    query_proto)

muduo_add_executable(protobuf_client client.cc)
muduo_target_uses_protobuf(protobuf_client)
muduo_target_no_shadow_error(protobuf_client)
target_link_libraries(protobuf_client
  PRIVATE
    protobuf_codec
    query_proto)

add_custom_target(protobuf_codec_all
  DEPENDS
    protobuf_codec_test
    protobuf_dispatcher_lite_test
    protobuf_dispatcher_test
    protobuf_server
    protobuf_client)

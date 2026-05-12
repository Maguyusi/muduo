muduo_protobuf_generate_cpp(SUDOKU_PROTO_SRC SUDOKU_PROTO_HDR sudoku.proto)
muduo_target_generated_protobuf_source("${SUDOKU_PROTO_SRC}")

muduo_add_library(sudoku_proto "${SUDOKU_PROTO_SRC}")
muduo_target_uses_protobuf(sudoku_proto)
target_include_directories(sudoku_proto PUBLIC "${PROJECT_BINARY_DIR}")
target_link_libraries(sudoku_proto
  PUBLIC
    muduo::protobuf
    Threads::Threads)

muduo_add_executable(protobuf_rpc_sudoku_client client.cc)
muduo_target_uses_protobuf(protobuf_rpc_sudoku_client)
muduo_target_no_shadow_error(protobuf_rpc_sudoku_client)
target_link_libraries(protobuf_rpc_sudoku_client
  PRIVATE
    sudoku_proto
    muduo_protorpc)

muduo_add_executable(protobuf_rpc_sudoku_server server.cc)
muduo_target_uses_protobuf(protobuf_rpc_sudoku_server)
muduo_target_no_shadow_error(protobuf_rpc_sudoku_server)
target_link_libraries(protobuf_rpc_sudoku_server
  PRIVATE
    sudoku_proto
    muduo_protorpc)

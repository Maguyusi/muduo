add_subdirectory(codec)
add_subdirectory(rpc)
add_subdirectory(rpcbalancer)
add_subdirectory(rpcbench)

if(TARGET muduo::cares)
  add_subdirectory(resolver)
endif()

set(PROTOBUF_RPC_TARGETS
  muduo_protorpc
  protobuf_rpc_balancer
  protobuf_rpc_balancer_raw
  protobuf_rpc_echo_client
  protobuf_rpc_echo_server
  protobuf_rpc_sudoku_client
  protobuf_rpc_sudoku_server)

if(TARGET protobuf_rpc_resolver_client)
  list(APPEND PROTOBUF_RPC_TARGETS protobuf_rpc_resolver_client)
endif()
if(TARGET protobuf_rpc_resolver_server)
  list(APPEND PROTOBUF_RPC_TARGETS protobuf_rpc_resolver_server)
endif()

add_custom_target(protobuf_rpc_all DEPENDS ${PROTOBUF_RPC_TARGETS})

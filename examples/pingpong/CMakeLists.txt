muduo_add_executable(pingpong_client client.cc)
target_link_libraries(pingpong_client PRIVATE muduo_net)

muduo_add_executable(pingpong_server server.cc)
target_link_libraries(pingpong_server PRIVATE muduo_net)

muduo_add_executable(pingpong_bench bench.cc)
target_link_libraries(pingpong_bench PRIVATE muduo_net)


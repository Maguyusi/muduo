muduo_add_executable(balancer balancer.cc)
target_link_libraries(balancer PRIVATE muduo_net)

muduo_add_executable(tcprelay tcprelay.cc)
target_link_libraries(tcprelay PRIVATE muduo_net)

muduo_add_executable(socks4a socks4a.cc)
target_link_libraries(socks4a PRIVATE muduo_net)


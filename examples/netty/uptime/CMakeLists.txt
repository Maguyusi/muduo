muduo_add_executable(netty_uptime uptime.cc)
target_link_libraries(netty_uptime PRIVATE muduo_net)


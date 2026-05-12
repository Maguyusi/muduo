muduo_add_executable(roundtrip roundtrip.cc)
target_link_libraries(roundtrip PRIVATE muduo_net)

muduo_add_executable(roundtrip_udp roundtrip_udp.cc)
target_link_libraries(roundtrip_udp PRIVATE muduo_net)


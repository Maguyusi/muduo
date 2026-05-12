muduo_add_executable(hub hub.cc codec.cc)
target_link_libraries(hub PRIVATE muduo_inspect)

muduo_add_library(muduo_pubsub pubsub.cc codec.cc)
target_link_libraries(muduo_pubsub PRIVATE muduo_net)

muduo_add_executable(pub pub.cc)
target_link_libraries(pub PRIVATE muduo_pubsub)

muduo_add_executable(sub sub.cc)
target_link_libraries(sub PRIVATE muduo_pubsub)


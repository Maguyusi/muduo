muduo_add_executable(procmon procmon.cc plot.cc)
target_link_libraries(procmon PRIVATE muduo_http muduo::gd)

muduo_add_executable(plot_test plot_test.cc plot.cc)
target_link_libraries(plot_test PRIVATE muduo_base muduo::gd)

muduo_add_executable(dummyload dummyload.cc)
target_link_libraries(dummyload PRIVATE muduo_net)

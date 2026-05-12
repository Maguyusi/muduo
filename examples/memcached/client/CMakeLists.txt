if(TARGET muduo::boost_program_options)
  muduo_add_executable(memcached_bench bench.cc)
  target_link_libraries(memcached_bench
    PRIVATE
      muduo_net
      muduo::boost_program_options)
endif()

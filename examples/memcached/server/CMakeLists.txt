if(TARGET muduo::boost_program_options)
  muduo_add_executable(memcached_debug Item.cc MemcacheServer.cc Session.cc server.cc)
  target_link_libraries(memcached_debug
    PRIVATE
      muduo_net
      muduo_inspect
      muduo::boost_program_options)
endif()

muduo_add_executable(memcached_footprint Item.cc MemcacheServer.cc Session.cc footprint_test.cc)
target_link_libraries(memcached_footprint PRIVATE muduo_net muduo_inspect)

if(TARGET muduo::tcmalloc)
  target_compile_definitions(memcached_footprint PRIVATE HAVE_TCMALLOC)
  target_link_libraries(memcached_footprint PRIVATE muduo::tcmalloc)
  if(TARGET memcached_debug)
    target_compile_definitions(memcached_debug PRIVATE HAVE_TCMALLOC)
    target_link_libraries(memcached_debug PRIVATE muduo::tcmalloc)
  endif()
endif()

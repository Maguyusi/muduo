if(TARGET muduo::boost_program_options)
  muduo_add_executable(ttcp_blocking ttcp_blocking.cc common.cc main.cc)
  target_compile_options(ttcp_blocking PRIVATE -Wno-error=old-style-cast -Wno-error=conversion)
  target_link_libraries(ttcp_blocking
    PRIVATE
      muduo_base
      muduo::boost_program_options)

  muduo_add_executable(ttcp_muduo ttcp.cc common.cc main.cc)
  target_link_libraries(ttcp_muduo
    PRIVATE
      muduo_net
      muduo::boost_program_options)

  if(TARGET muduo::boost_system)
    muduo_add_executable(ttcp_asio_sync ttcp_asio_sync.cc common.cc main.cc)
    target_link_libraries(ttcp_asio_sync
      PRIVATE
        muduo_base
        muduo::boost_program_options
        muduo::boost_system)

    muduo_add_executable(ttcp_asio_async ttcp_asio_async.cc common.cc main.cc)
    target_link_libraries(ttcp_asio_async
      PRIVATE
        muduo_base
        muduo::boost_program_options
        muduo::boost_system)
  endif()
endif()

muduo_add_executable(channel_test Channel_test.cc)
target_link_libraries(channel_test PRIVATE muduo_net)

muduo_add_executable(echoserver_unittest EchoServer_unittest.cc)
target_link_libraries(echoserver_unittest PRIVATE muduo_net)

muduo_add_executable(echoclient_unittest EchoClient_unittest.cc)
target_link_libraries(echoclient_unittest PRIVATE muduo_net)

muduo_add_executable(eventloop_unittest EventLoop_unittest.cc)
target_link_libraries(eventloop_unittest PRIVATE muduo_net)

muduo_add_executable(eventloopthread_unittest EventLoopThread_unittest.cc)
target_link_libraries(eventloopthread_unittest PRIVATE muduo_net)

muduo_add_executable(eventloopthreadpool_unittest EventLoopThreadPool_unittest.cc)
target_link_libraries(eventloopthreadpool_unittest PRIVATE muduo_net)

if(TARGET muduo::boost_unit_test_framework)
  muduo_add_executable(buffer_unittest Buffer_unittest.cc)
  target_link_libraries(buffer_unittest
    PRIVATE
      muduo_net
      muduo::boost_unit_test_framework)
  add_test(NAME buffer_unittest COMMAND buffer_unittest)

  muduo_add_executable(inetaddress_unittest InetAddress_unittest.cc)
  target_link_libraries(inetaddress_unittest
    PRIVATE
      muduo_net
      muduo::boost_unit_test_framework)
  add_test(NAME inetaddress_unittest COMMAND inetaddress_unittest)

  if(ZLIB_FOUND)
    muduo_add_executable(zlibstream_unittest ZlibStream_unittest.cc)
    target_link_libraries(zlibstream_unittest
      PRIVATE
        muduo_net
        muduo::boost_unit_test_framework
        ZLIB::ZLIB)
  endif()
endif()

muduo_add_executable(tcpclient_reg1 TcpClient_reg1.cc)
target_link_libraries(tcpclient_reg1 PRIVATE muduo_net)

muduo_add_executable(tcpclient_reg2 TcpClient_reg2.cc)
target_link_libraries(tcpclient_reg2 PRIVATE muduo_net)

muduo_add_executable(tcpclient_reg3 TcpClient_reg3.cc)
target_link_libraries(tcpclient_reg3 PRIVATE muduo_net)

muduo_add_executable(timerqueue_unittest TimerQueue_unittest.cc)
target_link_libraries(timerqueue_unittest PRIVATE muduo_net)
add_test(NAME timerqueue_unittest COMMAND timerqueue_unittest)

include(CheckFunctionExists)

check_function_exists(accept4 HAVE_ACCEPT4)

set(net_SRCS
  Acceptor.cc
  Buffer.cc
  Channel.cc
  Connector.cc
  EventLoop.cc
  EventLoopThread.cc
  EventLoopThreadPool.cc
  InetAddress.cc
  Poller.cc
  poller/DefaultPoller.cc
  poller/EPollPoller.cc
  poller/PollPoller.cc
  Socket.cc
  SocketsOps.cc
  TcpClient.cc
  TcpConnection.cc
  TcpServer.cc
  Timer.cc
  TimerQueue.cc
  )

muduo_add_library(muduo_net ${net_SRCS})
target_include_directories(muduo_net
  PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>"
    "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>")
target_link_libraries(muduo_net PUBLIC muduo_base)

if(NOT HAVE_ACCEPT4)
  target_compile_definitions(muduo_net PRIVATE NO_ACCEPT4)
endif()

muduo_install_library(muduo_net)

set(HEADERS
  Buffer.h
  Callbacks.h
  Channel.h
  Endian.h
  EventLoop.h
  EventLoopThread.h
  EventLoopThreadPool.h
  InetAddress.h
  TcpClient.h
  TcpConnection.h
  TcpServer.h
  TimerId.h
  )
install(FILES ${HEADERS} DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/muduo/net")

add_subdirectory(http)
add_subdirectory(inspect)

if(MUDUO_BUILD_EXAMPLES)
  add_subdirectory(tests)
endif()

if(MUDUO_PROTOBUF_FOUND)
  add_subdirectory(protobuf)
  add_subdirectory(protorpc)
endif()

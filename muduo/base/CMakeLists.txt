set(base_SRCS
  AsyncLogging.cc
  Condition.cc
  CountDownLatch.cc
  CurrentThread.cc
  Date.cc
  Exception.cc
  FileUtil.cc
  LogFile.cc
  Logging.cc
  LogStream.cc
  ProcessInfo.cc
  Timestamp.cc
  Thread.cc
  ThreadPool.cc
  TimeZone.cc
  )

muduo_add_library(muduo_base ${base_SRCS})
target_include_directories(muduo_base
  PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>"
    "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>")
target_link_libraries(muduo_base
  PUBLIC
    Threads::Threads
  PRIVATE
    rt)

muduo_install_library(muduo_base)

file(GLOB HEADERS "*.h")
install(FILES ${HEADERS} DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/muduo/base")

if(MUDUO_BUILD_EXAMPLES)
  add_subdirectory(tests)
endif()

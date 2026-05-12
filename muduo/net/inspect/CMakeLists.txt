set(inspect_SRCS
  Inspector.cc
  PerformanceInspector.cc
  ProcessInspector.cc
  SystemInspector.cc
  )

muduo_add_library(muduo_inspect ${inspect_SRCS})
target_link_libraries(muduo_inspect PUBLIC muduo_http)

if(TARGET muduo::tcmalloc)
  target_compile_definitions(muduo_inspect PRIVATE HAVE_TCMALLOC)
  target_link_libraries(muduo_inspect PRIVATE muduo::tcmalloc)
endif()

muduo_install_library(muduo_inspect)
set(HEADERS
  Inspector.h
  )
install(FILES ${HEADERS} DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/muduo/net/inspect")

if(MUDUO_BUILD_EXAMPLES)
  muduo_add_executable(inspector_test tests/Inspector_test.cc)
  target_link_libraries(inspector_test PRIVATE muduo_inspect)
endif()


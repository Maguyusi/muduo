set(http_SRCS
  HttpServer.cc
  HttpResponse.cc
  HttpContext.cc
  )

muduo_add_library(muduo_http ${http_SRCS})
target_link_libraries(muduo_http PUBLIC muduo_net)

muduo_install_library(muduo_http)
set(HEADERS
  HttpContext.h
  HttpRequest.h
  HttpResponse.h
  HttpServer.h
  )
install(FILES ${HEADERS} DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/muduo/net/http")

if(MUDUO_BUILD_EXAMPLES)
  muduo_add_executable(httpserver_test tests/HttpServer_test.cc)
  target_link_libraries(httpserver_test PRIVATE muduo_http)

  if(TARGET muduo::boost_unit_test_framework)
    muduo_add_executable(httprequest_unittest tests/HttpRequest_unittest.cc)
    target_link_libraries(httprequest_unittest
      PRIVATE
        muduo_http
        muduo::boost_unit_test_framework)
  endif()
endif()

muduo_add_library(muduo_cdns Resolver.cc)
target_link_libraries(muduo_cdns
  PUBLIC
    muduo_net
  PRIVATE
    muduo::cares)

muduo_install_library(muduo_cdns)
install(FILES Resolver.h DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/muduo/cdns")

muduo_add_executable(cdns dns.cc)
target_link_libraries(cdns PRIVATE muduo_cdns)

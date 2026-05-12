muduo_add_library(muduo_curl Curl.cc)
target_link_libraries(muduo_curl
  PUBLIC
    muduo_net
  PRIVATE
    CURL::libcurl)

muduo_install_library(muduo_curl)
install(FILES Curl.h DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/muduo/curl")

muduo_add_executable(mcurl mcurl.cc)
target_link_libraries(mcurl PRIVATE muduo_curl)

muduo_add_executable(curl_download download.cc)
target_link_libraries(curl_download PRIVATE muduo_curl)

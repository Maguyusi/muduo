muduo_add_executable(shorturl shorturl.cc)
target_link_libraries(shorturl PRIVATE muduo_http)


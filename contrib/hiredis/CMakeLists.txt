muduo_add_executable(mrediscli Hiredis.cc mrediscli.cc)
target_link_libraries(mrediscli
  PRIVATE
    muduo_net
    muduo::hiredis)

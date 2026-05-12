if(TARGET muduo::hiredis)
  add_subdirectory(hiredis)
endif()

if(THRIFT_COMPILER AND TARGET muduo::thrift)
  add_subdirectory(thrift)
endif()

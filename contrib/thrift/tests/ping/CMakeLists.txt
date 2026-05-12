set(PING_THRIFT ping.thrift)
execute_process(COMMAND ${THRIFT_COMPILER} --gen cpp ${PING_THRIFT}
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
execute_process(COMMAND ${THRIFT_COMPILER} --gen py ${PING_THRIFT}
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
set(PING_THRIFT_SRCS
    gen-cpp/ping_constants.cpp
    gen-cpp/ping_types.cpp
    gen-cpp/Ping.cpp
    )
set(PING_SRCS
    PingServer.cc
    )
muduo_add_executable(muduo_thrift_ping ${PING_SRCS} ${PING_THRIFT_SRCS})
target_include_directories(muduo_thrift_ping PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/gen-cpp")
target_link_libraries(muduo_thrift_ping PRIVATE muduo_thrift)

muduo_add_executable(maxconnection_echo echo.cc main.cc)
target_link_libraries(maxconnection_echo PRIVATE muduo_net)

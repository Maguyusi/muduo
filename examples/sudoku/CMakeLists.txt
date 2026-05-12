muduo_add_executable(sudoku_solver_basic server_basic.cc sudoku.cc)
target_link_libraries(sudoku_solver_basic PRIVATE muduo_net)

muduo_add_executable(sudoku_solver_multiloop server_multiloop.cc sudoku.cc)
target_link_libraries(sudoku_solver_multiloop PRIVATE muduo_net)

muduo_add_executable(sudoku_solver_threadpool server_threadpool.cc sudoku.cc)
target_link_libraries(sudoku_solver_threadpool PRIVATE muduo_net)

muduo_add_executable(sudoku_solver_hybrid server_hybrid.cc sudoku.cc)
target_link_libraries(sudoku_solver_hybrid PRIVATE muduo_inspect)

muduo_add_executable(sudoku_solver_prod server_prod.cc sudoku.cc)
target_link_libraries(sudoku_solver_prod PRIVATE muduo_inspect)


muduo_add_executable(sudoku_client_batch batch.cc sudoku.cc)
target_link_libraries(sudoku_client_batch PRIVATE muduo_net)

muduo_add_executable(sudoku_client_pipeline pipeline.cc sudoku.cc)
target_link_libraries(sudoku_client_pipeline PRIVATE muduo_net)

muduo_add_executable(sudoku_loadtest loadtest.cc sudoku.cc)
target_link_libraries(sudoku_loadtest PRIVATE muduo_net)


if(TARGET muduo::boost_unit_test_framework)
  muduo_add_executable(sudoku_stat_unittest stat_unittest.cc)
  target_link_libraries(sudoku_stat_unittest
    PRIVATE
      muduo_base
      muduo::boost_unit_test_framework)
endif()

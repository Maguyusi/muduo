include(CheckFunctionExists)

function(muduo_set_default_build_type)
  if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS Debug Release RelWithDebInfo MinSizeRel)
  endif()
endfunction()

function(muduo_add_library target)
  add_library(${target} ${ARGN})
  target_link_libraries(${target}
    PUBLIC muduo_public_config
    PRIVATE muduo_private_options)
endfunction()

function(muduo_add_executable target)
  add_executable(${target} ${ARGN})
  target_link_libraries(${target}
    PRIVATE muduo_public_config muduo_private_options)
endfunction()

function(muduo_install_library target)
  install(TARGETS ${target}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
endfunction()

function(muduo_target_no_shadow_error target)
  target_compile_options(${target} PRIVATE -Wno-error=shadow)
endfunction()

function(muduo_target_generated_protobuf_source source)
  set_source_files_properties(${source}
    PROPERTIES COMPILE_OPTIONS "-Wno-conversion;-Wno-shadow")
endfunction()

function(muduo_target_uses_protobuf target)
  target_compile_features(${target} PUBLIC cxx_std_20)
endfunction()

function(muduo_create_library_dependency target include_dir library)
  if(${include_dir} AND ${library} AND NOT TARGET ${target})
    add_library(${target} INTERFACE IMPORTED GLOBAL)
    target_include_directories(${target} INTERFACE "${${include_dir}}")
    target_link_libraries(${target} INTERFACE "${${library}}")
  endif()
endfunction()

function(muduo_create_link_dependency target library)
  if(${library} AND NOT TARGET ${target})
    add_library(${target} INTERFACE IMPORTED GLOBAL)
    target_link_libraries(${target} INTERFACE "${${library}}")
  endif()
endfunction()

function(muduo_protobuf_generate_cpp out_src out_hdr proto)
  if(NOT MUDUO_PROTOC)
    message(FATAL_ERROR "Protobuf compiler is required to generate ${proto}")
  endif()

  get_filename_component(_proto_abs "${proto}" ABSOLUTE BASE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
  get_filename_component(_proto_name "${proto}" NAME_WE)
  file(RELATIVE_PATH _proto_dir "${PROJECT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
  set(_proto_out_dir "${PROJECT_BINARY_DIR}/${_proto_dir}")
  set(_proto_src "${_proto_out_dir}/${_proto_name}.pb.cc")
  set(_proto_hdr "${_proto_out_dir}/${_proto_name}.pb.h")

  add_custom_command(
    OUTPUT "${_proto_src}" "${_proto_hdr}"
    COMMAND ${CMAKE_COMMAND} -E make_directory "${_proto_out_dir}"
    COMMAND ${MUDUO_PROTOC}
    ARGS --cpp_out "${PROJECT_BINARY_DIR}"
         "${_proto_abs}"
         -I "${PROJECT_SOURCE_DIR}"
    DEPENDS "${_proto_abs}"
    VERBATIM)

  set(${out_src} "${_proto_src}" PARENT_SCOPE)
  set(${out_hdr} "${_proto_hdr}" PARENT_SCOPE)
endfunction()

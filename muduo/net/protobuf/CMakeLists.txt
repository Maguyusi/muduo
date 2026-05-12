muduo_add_library(muduo_protobuf_codec ProtobufCodecLite.cc)
muduo_target_uses_protobuf(muduo_protobuf_codec)
muduo_target_no_shadow_error(muduo_protobuf_codec)
target_link_libraries(muduo_protobuf_codec
  PUBLIC
    muduo_net
    muduo::protobuf
  PRIVATE
    ZLIB::ZLIB)

muduo_install_library(muduo_protobuf_codec)

file(GLOB HEADERS "*.h")
install(FILES ${HEADERS} DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/muduo/net/protobuf")

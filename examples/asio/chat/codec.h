#ifndef MUDUO_EXAMPLES_ASIO_CHAT_CODEC_H
#define MUDUO_EXAMPLES_ASIO_CHAT_CODEC_H

#include "muduo/base/Logging.h"
#include "muduo/net/Buffer.h"
#include "muduo/net/Endian.h"
#include "muduo/net/TcpConnection.h"
#include <limits>

class LengthHeaderCodec : muduo::noncopyable {
public:
  typedef std::function<void(const muduo::net::TcpConnectionPtr &,
                             const muduo::string &message, muduo::Timestamp)>
      StringMessageCallback;

  explicit LengthHeaderCodec(const StringMessageCallback &cb)
      : messageCallback_(cb) {}

  void onMessage(const muduo::net::TcpConnectionPtr &conn,
                 muduo::net::Buffer *buf, muduo::Timestamp receiveTime) {
    while (buf->readableBytes() >= kHeaderLen) // kHeaderLen == 4
    {
      // FIXME: use Buffer::peekInt32()
      const void *data = buf->peek();
      int32_t be32 = *static_cast<const int32_t *>(data); // SIGBUS
      const int32_t len = muduo::net::sockets::networkToHost32(be32);
      if (len > 65536 || len < 0) {
        LOG_ERROR << "Invalid length " << len;
        conn->shutdown(); // FIXME: disable reading
        break;
      } else if (buf->readableBytes() >= len + kHeaderLen) {
        buf->retrieve(kHeaderLen);
        muduo::string message(buf->peek(), len);
        messageCallback_(conn, message, receiveTime);
        buf->retrieve(len);
      } else {
        break;
      }
    }
  }

  // FIXME: TcpConnectionPtr

  void send(muduo::net::TcpConnection *conn,
            const muduo::StringPiece &message) {
    const int len = message.size();

    if (len < 0 || len > std::numeric_limits<int32_t>::max()) {
      conn->shutdown();
      return;
    }

    muduo::net::Buffer buf(sizeof(int32_t) + static_cast<size_t>(len));

    buf.appendInt32(static_cast<int32_t>(len));
    buf.append(message.data(), static_cast<size_t>(len));

    conn->send(&buf);
  }

private:
  StringMessageCallback messageCallback_;
  const static size_t kHeaderLen = sizeof(int32_t);
};

#endif // MUDUO_EXAMPLES_ASIO_CHAT_CODEC_H

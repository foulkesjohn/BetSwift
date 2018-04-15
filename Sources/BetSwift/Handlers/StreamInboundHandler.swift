import Foundation
import NIO

public class StreamInboundHandler: ChannelInboundHandler {
  public typealias InboundIn = ByteBuffer
  public typealias InboundOut = Op
  
  private let decoder = JSONDecoder()
  
  public init() {
    decoder.dateDecodingStrategy = .millisecondsSince1970
  }
  
  public func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
    var buffer = self.unwrapInboundIn(data)
    if let bytes = buffer.readBytes(length: buffer.readableBytes) {
      let data = Data(bytes: bytes)
      if let op = try? decoder.decode(Op.self, from: data) {
        ctx.fireChannelRead(wrapInboundOut(op))
      }
    }
  }
}


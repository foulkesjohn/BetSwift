import Foundation
import NIO

public class StreamInboundHandler: ChannelInboundHandler {
  public typealias InboundIn = ByteBuffer
  public typealias InboundOut = Op
  
  public init() {}
  
  public func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
    var buffer = self.unwrapInboundIn(data)
    if let bytes = buffer.readBytes(length: buffer.readableBytes) {
      let data = Data(bytes: bytes)
      if let op = try? JSONDecoder().decode(Op.self, from: data) {
        ctx.fireChannelRead(wrapInboundOut(op))
      }
    }
  }
  
  public func errorCaught(ctx: ChannelHandlerContext, error: Error) {
    ctx.close(promise: nil)
  }
}

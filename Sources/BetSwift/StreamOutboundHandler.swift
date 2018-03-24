import Foundation
import NIO

public class StreamOutboundHandler: ChannelOutboundHandler {
  public typealias OutboundIn = Op
  public typealias OutboundOut = ByteBuffer
  
  private let encoder = JSONEncoder()
  private let newLine = "\r\n"
  
  public init() {}
  
  public func write(ctx: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
    let op = unwrapOutboundIn(data)
    let outMessage = message(from: op)
    var buffer = ctx.channel.allocator.buffer(capacity: outMessage.utf8.count)
    buffer.write(string: outMessage)
    ctx.writeAndFlush(wrapOutboundOut(buffer), promise: nil)
  }
  
  private func message(from op: Op) -> String {
    let messageData = try! encoder.encode(op)
    let message = String(data: messageData,
                         encoding: .utf8)!
    return message + newLine
  }
}

import Foundation
import NIO

public final class LineDelimiterCodec: ByteToMessageDecoder {
  public typealias InboundIn = ByteBuffer
  public typealias InboundOut = ByteBuffer
  
  public var cumulationBuffer: ByteBuffer?
  private let newLine = "\r\n".utf8.first!
  
  public init() {}
  
  public func decode(ctx: ChannelHandlerContext,
                     buffer: inout ByteBuffer) throws -> DecodingState {
    let readable = buffer.withUnsafeReadableBytes { $0.firstIndex(of: newLine) }
    if let r = readable {
      ctx.fireChannelRead(self.wrapInboundOut(buffer.readSlice(length: r + 1)!))
      return .continue
    }
    return .needMoreData
  }
}

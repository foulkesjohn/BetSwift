import Foundation
import NIO

public final class LineDelimiterCodec: ByteToMessageDecoder {
  public typealias InboundIn = ByteBuffer
  public typealias InboundOut = ByteBuffer
  
  public var cumulationBuffer: ByteBuffer?
  private let newLine = "\r\n".utf8.first!
  
  public init() {}
  
  public func decode(context: ChannelHandlerContext,
                     buffer: inout ByteBuffer) throws -> DecodingState {
    return _decode(context: context, buffer: &buffer)
  }
  
  public func decodeLast(context: ChannelHandlerContext,
                         buffer: inout ByteBuffer,
                         seenEOF: Bool) throws -> DecodingState {
    return _decode(context: context, buffer: &buffer)
  }
  
  private func _decode(context: ChannelHandlerContext,
                      buffer: inout ByteBuffer) -> DecodingState {
    let readable = buffer.withUnsafeReadableBytes { $0.firstIndex(of: newLine) }
    if let r = readable {
      context.fireChannelRead(self.wrapInboundOut(buffer.readSlice(length: r + 1)!))
      return .continue
    }
    return .needMoreData
  }
}

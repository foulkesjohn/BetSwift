import Foundation

public struct CancelExecutionReport: Codable {
  public let customerRef: String?
  public let status: String
  public let errorCode: String?
  public let marketId: String?
  public let instructionReports: [CancelOrders.CancelInstruction]?
}

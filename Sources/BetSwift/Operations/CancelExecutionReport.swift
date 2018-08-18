import Foundation

public struct CancelExecutionReport: Codable {
  public enum ExecutionReportStatus: String {
    case success = "SUCCESS"
    case failure = "FAILURE"
    case PROCESSED_WITH_ERRORS = "PROCESSED_WITH_ERRORS"
    case TIMEOUT = "TIMEOUT"
  }
  public struct CancelInstructionReport: Codable {
    public let status: String
    public let errorCode: String?
    public let instruction: CancelOrders.CancelInstruction?
    public let sizeCancelled: Double
    public let cancelledDate: Date?
  }
  public let customerRef: String?
  public let status: String
  public let errorCode: String?
  public let marketId: String?
  public let instructionReports: [CancelInstructionReport]?
}

import Foundation

public struct PlaceExecutionReport: Codable, EndpointType {
  public enum ExecutionReportStatus: String, Codable {
    case success = "SUCCESS"
    case failure = "FAILURE"
    case processedWithErrors = "PROCESSED_WITH_ERRORS"
    case timeout = "TIMEOUT"
  }
  public enum ExecutionReportErrorCode: String, Codable {
    case ERROR_IN_MATCHER
    case PROCESSED_WITH_ERRORS
    case BET_ACTION_ERROR
    case INVALID_ACCOUNT_STATE
    case INVALID_WALLET_STATUS
    case INSUFFICIENT_FUNDS
    case LOSS_LIMIT_EXCEEDED
    case MARKET_SUSPENDED
    case MARKET_NOT_OPEN_FOR_BETTING
    case DUPLICATE_TRANSACTION
    case INVALID_ORDER
    case INVALID_MARKET_ID
    case PERMISSION_DENIED
    case DUPLICATE_BETIDS
    case NO_ACTION_REQUIRED
    case SERVICE_UNAVAILABLE
    case REJECTED_BY_REGULATOR
    case NO_CHASING
    case REGULATOR_IS_NOT_AVAILABLE
    case TOO_MANY_INSTRUCTIONS
    case INVALID_MARKET_VERSION
  }
  public struct PlaceInstructionReport: Codable {
    public enum InstructionReportStatus: String, Codable {
      case success = "SUCCESS"
      case failure = "FAILURE"
      case timeout = "TIMEOUT"
    }
    public let status: InstructionReportStatus
    public let errorCode: String?
    public let orderStatus: OrderStatus?
    public let instruction: PlaceInstruction
    public let betId: String?
    public let placedDate: Date?
    public let averagePriceMatched: Float?
    public let sizeMatched: Float?
  }
  public let customerRef: String?
  public let status: ExecutionReportStatus
  public let errorCode: ExecutionReportErrorCode?
  public let marketId: String?
  public let instructionReports: [PlaceInstructionReport]?
  public var url: URL {
    return Endpoint.Betting.placeOrders.url
  }
}

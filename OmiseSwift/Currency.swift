import Foundation


public let centBasedCurrencyFactor = 100
public let identicalBasedCurrencyFactor = 1

public enum Currency {
  case THB
  case JPY
  case Custom(code: String, factor: Int)
  
  
  public var code: String {
    switch self {
    case .THB:
      return "THB"
    case .JPY:
      return "JPY"
    case.Custom(code: let code, factor: _):
      return code
    }
  }
  
  /// A convertion factor represents how much Omise amount equals to 1 unit of this currency. eg. THB's factor is equals to 100.
  public var factor: Int {
    switch self {
    case .THB:
      return centBasedCurrencyFactor
    case .JPY:
      return identicalBasedCurrencyFactor
    case .Custom(code: _, factor: let factor):
      return factor
    }
  }
  
  public func convertFromSubunit(value: Int64) -> Double {
    return Double(value) / Double(factor)
  }
  
  public func convertToSubunit(value: Double) -> Int64 {
    return Int64(value * Double(factor))
  }
  
  public init?(code: String) {
    switch code.uppercased() {
    case "THB":
      self = .THB
    case "JPY":
      self = .JPY
    default: return nil
    }
  }
}



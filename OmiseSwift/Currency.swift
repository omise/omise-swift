import Foundation

public let centBasedCurrencyFactor = 100
public let identicalBasedCurrencyFactor = 1

public enum Currency {
    case thb
    case jpy
    case custom(code: String, factor: Int)
    
    
    public var code: String {
        switch self {
        case .thb:
            return "THB"
        case .jpy:
            return "JPY"
        case.custom(code: let code, factor: _):
            return code
        }
    }
    
    /// A convertion factor represents how much Omise amount equals to 1 unit of this currency. eg. THB's factor is equals to 100.
    public var factor: Int {
        switch self {
        case .thb:
            return centBasedCurrencyFactor
        case .jpy:
            return identicalBasedCurrencyFactor
        case .custom(code: _, factor: let factor):
            return factor
        }
    }
    
    public func convert(fromSubunit value: Int64) -> Double {
        return Double(value) / Double(factor)
    }
    
    public func convert(toSubunit value: Double) -> Int64 {
        return Int64(value * Double(factor))
    }
    
    public init?(code: String) {
        switch code.uppercased() {
        case "THB":
            self = .thb
        case "JPY":
            self = .jpy
        default: return nil
        }
    }
}

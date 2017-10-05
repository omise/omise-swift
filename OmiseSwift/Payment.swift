import Foundation


extension Card: Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
}

public enum Payment {
    case card(Card)
    case offsite(OffsitePayment)
    
    public var sourceOfFunds: String {
        switch self {
        case .card:
            return "card"
        case .offsite:
            return "offsite"
        }
    }
}

extension Payment: Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Payment, rhs: Payment) -> Bool {
        switch (lhs, rhs) {
        case (.card(let lhsCard), .card(let rhsCard)):
            return lhsCard == rhsCard
        case (.offsite(let lhsOffsite), .offsite(let rhsOffsite)):
            return lhsOffsite == rhsOffsite
        default:
            return false
        }
    }
}


public enum OffsitePayment: Codable {
    case internetBanking(InternetBanking)
    case alipay
    
    static let internetBankingPrefix = "internet_banking_"
    static let alipayValue = "alipay"
}

extension OffsitePayment {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let value = try container.decode(String.self)
        if value.hasPrefix(OffsitePayment.internetBankingPrefix),
            let internetBankingOffsite = value
                .range(of: OffsitePayment.internetBankingPrefix).map({ String(value[$0.upperBound...]) })
                .flatMap(InternetBanking.init(rawValue:)).map(OffsitePayment.internetBanking) {
            self = internetBankingOffsite
        } else if value == OffsitePayment.alipayValue {
            self = .alipay
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid/Unsupported Offsite Payment information")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        let offsiteValue: String
        switch self {
        case .internetBanking(let internetBanking):
            offsiteValue = OffsitePayment.internetBankingPrefix + internetBanking.rawValue
        case .alipay:
            offsiteValue = OffsitePayment.alipayValue
        }
        try container.encode(offsiteValue)
    }
}

extension OffsitePayment: Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: OffsitePayment, rhs: OffsitePayment) -> Bool {
        switch (lhs, rhs) {
        case (.internetBanking(let lhsBank), .internetBanking(let rhsBank)):
            return lhsBank == rhsBank
        case (.alipay, .alipay):
            return true
        case (.internetBanking, .alipay), (.alipay, .internetBanking):
            return false
        }
    }
}


public enum InternetBanking: String {
    case bay
    case bbl
    case ktb
    case scb
}

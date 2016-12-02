import Foundation


public enum Payment {
    case card(Card)
    case offsite(OffsitePayment)
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


public enum OffsitePayment {
    case internetBanking(InternetBanking)
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
        }
    }
}


public enum InternetBanking: String {
    case bay
    case bbl
    case scb
    case tmb
}

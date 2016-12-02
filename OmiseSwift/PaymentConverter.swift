import Foundation


class OffsitePaymentConverter: Converter {
    public typealias Target = OffsitePayment
    
    private static let internetBankingPrefix = "internet_banking_"
    public static func convert(fromAttribute value: Any?) -> Target? {
        guard let value = value as? String else { return nil }
        
        if value.hasPrefix(OffsitePaymentConverter.internetBankingPrefix), let prefixRange = value.range(of: OffsitePaymentConverter.internetBankingPrefix) {
            let bankBrand = value[prefixRange.upperBound..<value.endIndex]
            return InternetBanking(rawValue: bankBrand).map(OffsitePayment.internetBanking)
        } else {
            return nil
        }
    }
    
    public static func convert(fromValue value: Target?) -> Any? {
        switch value {
        case .internetBanking(let bank)?:
            return OffsitePaymentConverter.internetBankingPrefix + bank.rawValue
        default:
            return nil
        }
    }
}


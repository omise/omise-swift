import Foundation


class OffsitePaymentConverter: Converter {
    public typealias Target = OffsitePayment
    
    static let internetBankingPrefix = "internet_banking_"
    static let alipayValue = "alipay"
    
    public static func convert(fromAttribute value: Any?) -> Target? {
        guard let value = value as? String else { return nil }
        
        if value.hasPrefix(OffsitePaymentConverter.internetBankingPrefix), let prefixRange = value.range(of: OffsitePaymentConverter.internetBankingPrefix) {
            let bankBrand = value[prefixRange.upperBound..<value.endIndex]
            return InternetBanking(rawValue: String(bankBrand)).map(OffsitePayment.internetBanking)
        } else if value == OffsitePaymentConverter.alipayValue {
            return .alipay
        } else {
            return nil
        }
    }
    
    public static func convert(fromValue value: Target?) -> Any? {
        switch value {
        case .internetBanking(let bank)?:
            return OffsitePaymentConverter.internetBankingPrefix + bank.rawValue
        case .alipay?:
            return OffsitePaymentConverter.alipayValue
        default:
            return nil
        }
    }
}

 

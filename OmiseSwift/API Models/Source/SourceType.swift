import Foundation


let internetBankingPrefix = "internet_banking_"
let alipayValue = "alipay"
let promptPayValue = "promptpay"
let payNowValue = "paynow"
let billPaymentPrefix = "bill_payment_"
let barcodePrefix = "barcode_"
let installmentPrefix = "installment_"
let truemoneyValue = "truemoney"
let payWithPointsCitiValue = "points_citi"
let mobileBankingPrefix = "mobile_banking_"
let fpxValue = "fpx"

public enum InternetBanking: RawRepresentable, Equatable, Hashable {
    public init?(rawValue: String) {
        switch rawValue {
        case "bay":
            self = .bay
        case "bbl":
            self = .bbl
        case "ktb":
            self = .ktb
        case "scb":
            self = .scb
        case let value:
            self = .unknown(value)
        }
    }
    
    public var rawValue: String {
        switch self {
        case .bay:
            return "bay"
        case .bbl:
            return "bbl"
        case .ktb:
            return "ktb"
        case .scb:
            return "scb"
            
        case .unknown(let value):
            return value
        }
    }
    
    case bay
    case bbl
    case ktb
    case scb
    
    case unknown(String)
}

public enum MobileBanking: RawRepresentable, Equatable, Hashable {
    public init?(rawValue: String) {
        switch rawValue {
        case "bay":
            self = .bay
        case "bbl":
            self = .bbl
        case "ktb":
            self = .ktb
        case "scb":
            self = .scb
        case let value:
            self = .unknown(value)
        }
    }
    
    public var rawValue: String {
        switch self {
        case .bay:
            return "bay"
        case .bbl:
            return "bbl"
        case .ktb:
            return "ktb"
        case .scb:
            return "scb"
            
        case .unknown(let value):
            return value
        }
    }
    
    case bay
    case bbl
    case ktb
    case scb
    
    case unknown(String)
}

public struct FPX: Codable, Equatable, Hashable {
    public let email: String?
    public let bank: String
    
    public init(bank: String, email: String? = nil) {
        self.bank = bank
        self.email = email
    }
}

public enum SourceType: Codable, Equatable, Hashable {
    case internetBanking(InternetBanking)
    case alipay
    case promptPay
    case payNow
    case billPayment(BillPayment)
    case barcode(Barcode)
    case installment(InstallmentBrand)
    case truemoney
    case payWithPointsCiti
    case mobileBanking(MobileBanking)
    case fpx
    
    case unknown(String)
    
    public enum BillPayment: RawRepresentable, Equatable, Hashable {
        private static let tescoLotusValue = "tesco_lotus"
        case tescoLotus
        case unknown(String)
        
        public var rawValue: String {
            switch self {
            case .tescoLotus:
                return BillPayment.tescoLotusValue
            case .unknown(let value):
                return value
            }
        }
        
        public init?(rawValue: String) {
            switch rawValue {
            case BillPayment.tescoLotusValue:
                self = .tescoLotus
            case let value:
                self = .unknown(value)
            }
        }
    }
    
    public enum Barcode: RawRepresentable, Equatable, Hashable {
        private static let alipayValue = "alipay"
        private static let weChatPayValue = "wechat"
        
        case alipay
        case weChatPay
        case unknown(String)
        
        public var rawValue: String {
            switch self {
            case .alipay:
                return Barcode.alipayValue
            case .weChatPay:
                return Barcode.weChatPayValue
            case .unknown(let value):
                return value
            }
        }
        
        public init?(rawValue: String) {
            switch rawValue {
            case Barcode.alipayValue:
                self = .alipay
            case Barcode.weChatPayValue:
                self = .weChatPay
            case let value:
                self = .unknown(value)
            }
        }
    }
    
    public enum InstallmentBrand: RawRepresentable, Equatable, Codable, Hashable {
        case bay
        case firstChoice
        case bbl
        case ktc
        case kBank
        case scb
        case unknown(String)
        
        public init?(rawValue: String) {
            switch rawValue {
            case "bay":
                self = .bay
            case "first_choice":
                self = .firstChoice
            case "bbl":
                self = .bbl
            case "ktc":
                self = .ktc
            case "kbank":
                self = .kBank
            case "scb":
                self = .scb
            case let value:
                self = .unknown(value)
            }
        }
        
        public var rawValue: String {
            switch self {
            case .bay:
                return "bay"
            case .firstChoice:
                return "first_choice"
            case .bbl:
                return "bbl"
            case .ktc:
                return "ktc"
            case .scb:
                return "scb"
            case .kBank:
                return "kbank"
                
            case .unknown(let value):
                return value
            }
        }
    }
    
    var sourceTypePrefix: String {
        switch self {
        case .internetBanking:
            return internetBankingPrefix
        case .alipay:
            return alipayValue
        case .promptPay:
            return promptPayValue
        case .payNow:
            return payNowValue
        case .billPayment:
            return billPaymentPrefix
        case .barcode:
            return barcodePrefix
        case .truemoney:
            return truemoneyValue
        case .installment:
            return installmentPrefix
        case .payWithPointsCiti:
            return payWithPointsCitiValue
        case .mobileBanking:
            return mobileBankingPrefix
        case .fpx:
            return fpxValue
        case .unknown(let source):
            return source
        }
    }
    
    var value: String {
        let value: String
        switch self {
        case .internetBanking(let bank):
            value = internetBankingPrefix + bank.rawValue
        case .alipay:
            value = alipayValue
        case .promptPay:
            return promptPayValue
        case .payNow:
            return payNowValue
        case .billPayment(let bill):
            value = billPaymentPrefix + bill.rawValue
        case .barcode(let barcodeType):
            value = barcodePrefix + barcodeType.rawValue
        case .installment(let installmentBrand):
            value = installmentPrefix + installmentBrand.rawValue
        case .truemoney:
            value = truemoneyValue
        case .payWithPointsCiti:
            value = payWithPointsCitiValue
        case .mobileBanking(let bank):
            value = mobileBankingPrefix + bank.rawValue
        case .fpx:
            value = fpxValue
        case .unknown(let source):
            value = source
        }
        return value
    }
}


extension SourceType {
    
    // swiftlint:disable function_body_length
    init(apiSoureTypeValue value: String) {
        if value.hasPrefix(internetBankingPrefix),
            let internetBankingOffsite = value
                .range(of: internetBankingPrefix)
                .map({ String(value[$0.upperBound...]) })
                .flatMap(InternetBanking.init(rawValue:))
                .map(SourceType.internetBanking) {
            self = internetBankingOffsite
        } else if value == alipayValue {
            self = .alipay
        } else if value == promptPayValue {
            self = .promptPay
        } else if value == payNowValue {
            self = .payNow
        } else if value.hasPrefix(billPaymentPrefix),
            let billPaymentOffline = value
                .range(of: billPaymentPrefix)
                .map({ String(value[$0.upperBound...]) })
                .flatMap(BillPayment.init(rawValue:))
                .map(SourceType.billPayment) {
            self = billPaymentOffline
        } else if value.hasPrefix(installmentPrefix),
            let installment = value
                .range(of: installmentPrefix)
                .map({ String(value[$0.upperBound...]) })
                .flatMap(InstallmentBrand.init(rawValue:))
                .map(SourceType.installment) {
            self = installment
        } else if value.hasPrefix(barcodePrefix),
            let barcodeValue = value
                .range(of: barcodePrefix)
                .map({ String(value[$0.upperBound...]) })
                .flatMap(Barcode.init(rawValue:))
                .map(SourceType.barcode) {
            self = barcodeValue
        } else if value.hasPrefix(mobileBankingPrefix),
            let mobileBankingOffsite = value
                .range(of: mobileBankingPrefix)
                .map({ String(value[$0.upperBound...]) })
                .flatMap(MobileBanking.init(rawValue:))
                .map(SourceType.mobileBanking) {
            self = mobileBankingOffsite
        } else if value == fpxValue {
            self = .fpx
        } else {
            self = .unknown(value)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        self = SourceType(apiSoureTypeValue: try container.decode(String.self))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}


public struct Truemoney: Hashable, Codable {
    public let phoneNumber: String?
    
    public enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
    }
}

public struct ScannableCode: OmiseObject, Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case object
        case image
    }
    
    public let object: String
    public let image: Document
    
}

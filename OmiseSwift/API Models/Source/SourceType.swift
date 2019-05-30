import Foundation


let internetBankingPrefix = "internet_banking_"
let alipayValue = "alipay"
let billPaymentPrefix = "bill_payment_"
let virtualAccountPrefix = "virtual_account_"
let barcodePrefix = "barcode_"
let installmentPrefix = "installment_"


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


public enum SourceType: Codable, Equatable, Hashable {
    case internetBanking(InternetBanking)
    case alipay
    case billPayment(BillPayment)
    case virtualAccount(VirtualAccount)
    case barcode(Barcode)
    case installment(InstallmentBrand)
    
    case unknown(String)
    
    public enum BillPayment: RawRepresentable, Equatable, Hashable {
        static private let tescoLotusValue = "tesco_lotus"
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
    
    public enum VirtualAccount: RawRepresentable, Equatable, Hashable {
        static private let sinarmasValue = "sinarmas"
        
        case sinarmas
        case unknown(String)
        
        public var rawValue: String {
            switch self {
            case .sinarmas:
                return VirtualAccount.sinarmasValue
            case .unknown(let value):
                return value
            }
        }
        
        public init?(rawValue: String) {
            switch rawValue {
            case VirtualAccount.sinarmasValue:
                self = .sinarmas
            case let value:
                self = .unknown(value)
            }
        }
    }
    
    public enum Barcode: RawRepresentable, Equatable, Hashable {
        static private let alipayValue = "alipay"
        
        case alipay
        case unknown(String)
        
        public var rawValue: String {
            switch self {
            case .alipay:
                return Barcode.alipayValue
            case .unknown(let value):
                return value
            }
        }
        
        public init?(rawValue: String) {
            switch rawValue {
            case Barcode.alipayValue:
                self = .alipay
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
            
        case .billPayment:
            return billPaymentPrefix
        case .virtualAccount:
            return virtualAccountPrefix
        case .barcode:
            return barcodePrefix
        case .installment:
            return installmentPrefix
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
            
        case .billPayment(let bill):
            value = billPaymentPrefix + bill.rawValue
        case .virtualAccount(let account):
            value = virtualAccountPrefix + account.rawValue
        case .barcode(let barcodeType):
            value = barcodePrefix + barcodeType.rawValue
        case .installment(let installmentBrand):
            value = installmentPrefix + installmentBrand.rawValue
        case .unknown(let source):
            value = source
        }
        return value
    }
}


extension SourceType {
    init(apiSoureTypeValue value: String) {
        if value.hasPrefix(internetBankingPrefix),
            let internetBankingOffsite = value
                .range(of: internetBankingPrefix).map({ String(value[$0.upperBound...]) })
                .flatMap(InternetBanking.init(rawValue:)).map(SourceType.internetBanking) {
            self = internetBankingOffsite
        } else if value == alipayValue {
            self = .alipay
        } else if value.hasPrefix(billPaymentPrefix),
            let billPaymentOffline = value
                .range(of: billPaymentPrefix).map({ String(value[$0.upperBound...]) })
                .flatMap(BillPayment.init(rawValue:)).map(SourceType.billPayment) {
            self = billPaymentOffline
        } else if value.hasPrefix(installmentPrefix),
            let installment = value
                .range(of: installmentPrefix).map({ String(value[$0.upperBound...]) })
                .flatMap(InstallmentBrand.init(rawValue:)).map(SourceType.installment) {
            self = installment
        } else if value.hasPrefix(virtualAccountPrefix),
            let virtualAccountOffline = value
                .range(of: virtualAccountPrefix).map({ String(value[$0.upperBound...]) })
                .flatMap(VirtualAccount.init(rawValue:)).map(SourceType.virtualAccount) {
            self = virtualAccountOffline
        } else if value.hasPrefix(barcodePrefix),
            let barcodeValue = value
                .range(of: barcodePrefix).map({ String(value[$0.upperBound...]) })
                .flatMap(Barcode.init(rawValue:)).map(SourceType.barcode) {
            self = barcodeValue
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


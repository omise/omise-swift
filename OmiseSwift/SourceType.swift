import Foundation



let internetBankingPrefix = "internet_banking_"
let alipayValue = "alipay"
let billPaymentPrefix = "bill_payment_"
let virtualAccountPrefix = "virtual_account_"
let walletPrefix = "wallet_"



public enum InternetBanking: RawRepresentable {
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


public enum SourceType: Codable, Equatable {
    case internetBanking(InternetBanking)
    case alipay
    case billPayment(BillPayment)
    case virtualAccount(VirtualAccount)
    case wallet(Wallet)
    
    case unknown(String)
    
    public enum BillPayment: RawRepresentable {
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
    
    public enum VirtualAccount: RawRepresentable {
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
    
    public enum Wallet: RawRepresentable {
        static private let alipayValue = "alipay"
        
        case alipay
        case unknown(String)
        
        public var rawValue: String {
            switch self {
            case .alipay:
                return Wallet.alipayValue
            case .unknown(let value):
                return value
            }
        }
        
        public init?(rawValue: String) {
            switch rawValue {
            case Wallet.alipayValue:
                self = .alipay
            case let value:
                self = .unknown(value)
            }
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
        case .wallet(let walletType):
            value = walletPrefix + walletType.rawValue
        case .unknown(let source):
            value = source
        }
        return value
    }
    
    public static func ==(lhs: SourceType, rhs: SourceType) -> Bool {
        switch (lhs, rhs) {
        case (.internetBanking(let lhsBank), .internetBanking(let rhsBank)):
            return lhsBank == rhsBank
            
        case (.alipay, .alipay):
            return true
        case (.billPayment(let lhsBill), .billPayment(let rhsBill)):
            return lhsBill == rhsBill
            
        case (.virtualAccount(let lhsAccount), .virtualAccount(let rhsAccount)):
            return lhsAccount == rhsAccount
            
        case (.wallet(let lhsWallet), .wallet(let rhsWallet)):
            return lhsWallet == rhsWallet
            
        case (.unknown(let lhsSource), .unknown(let rhsSource)):
            return lhsSource == rhsSource
            
        default:
            return false
        }
    }
}


extension SourceType {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let value = try container.decode(String.self)
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
        } else if value.hasPrefix(virtualAccountPrefix),
            let virtualAccountOffline = value
                .range(of: virtualAccountPrefix).map({ String(value[$0.upperBound...]) })
                .flatMap(VirtualAccount.init(rawValue:)).map(SourceType.virtualAccount) {
            self = virtualAccountOffline
        } else if value.hasPrefix(walletPrefix),
            let walletValue = value
                .range(of: walletPrefix).map({ String(value[$0.upperBound...]) })
                .flatMap(Wallet.init(rawValue:)).map(SourceType.wallet) {
            self = walletValue
        } else {
            self = .unknown(value)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}


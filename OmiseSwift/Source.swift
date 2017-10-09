import Foundation


public enum Flow: String, Codable {
    case redirect
    case offline
}


let internetBankingPrefix = "internet_banking_"
let alipayValue = "alipay"
let billPaymentPrefix = "bill_payment_"
let virtualAccountPrefix = "virtual_account_"


public protocol SourceData: OmiseIdentifiableObject {
    associatedtype Payment: Codable
    
    var amount: Int64 { get }
    var currency: Currency { get }
    
    var flow: Flow { get }
    var type: Payment { get }
}

public enum SourceType: Codable, Equatable {
    case internetBanking(InternetBanking)
    case alipay
    case billPayment(BillPayment)
    case virtualAccount(VirtualAccount)
    
    public enum BillPayment: String {
        case tescoLotus = "tesco_lotus"
    }
    
    public enum VirtualAccount: String {
        case sinarmas
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
            
        default:
            return false
        }
    }
}


public struct PaymentSource: SourceData {
    public typealias Payment = SourceType
    
    public let id: String
    public let object: String
    
    public let currency: Currency
    public let amount: Int64
    
    public let flow: Flow
    public let type: SourceType
}

extension PaymentSource {
    private enum CodingKeys: String, CodingKey {
        case id
        case object
        case currency
        case amount
        case flow
        case type
        case references
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let references = try container.decodeIfPresent(Dictionary<String, Any>.self, forKey: .references)
        guard references == nil || references!.isEmpty else {
            throw DecodingError.dataCorruptedError(forKey: .references, in: container, debugDescription: "\(Swift.type(of: self)) must not contain the enrolled references data")
        }
        
        id = try container.decode(String.self, forKey: .id)
        object = try container.decode(String.self, forKey: .object)
        currency = try container.decode(Currency.self, forKey: .currency)
        amount = try container.decode(Int64.self, forKey: .amount)
        flow = try container.decode(Flow.self, forKey: .flow)
        type = try container.decode(SourceType.self, forKey: .type)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(amount, forKey: .amount)
        try container.encode(currency, forKey: .currency)
        try container.encode(amount, forKey: .amount)
        try container.encode(flow, forKey: .flow)
        try container.encode(type, forKey: .type)
    }
}


extension SourceType {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let value = try container.decode(String.self)
        if value.hasPrefix(internetBankingPrefix),
            let internetBankingOffsite = value
                .range(of: internetBankingPrefix).map({ String(value[$0.upperBound...]) })
                .flatMap(InternetBanking.init(rawValue:)).map(PaymentSource.Payment.internetBanking) {
            self = internetBankingOffsite
        } else if value == OffsitePayment.alipayValue {
            self = .alipay
        } else if value.hasPrefix(billPaymentPrefix),
            let billPaymentOffline = value
                .range(of: billPaymentPrefix).map({ String(value[$0.upperBound...]) })
                .flatMap(PaymentSource.Payment.BillPayment.init(rawValue:)).map(PaymentSource.Payment.billPayment) {
            self = billPaymentOffline
        } else if value.hasPrefix(virtualAccountPrefix),
            let virtualAccountOffline = value
            .range(of: virtualAccountPrefix).map({ String(value[$0.upperBound...]) })
                .flatMap(PaymentSource.Payment.VirtualAccount.init(rawValue:)).map(PaymentSource.Payment.virtualAccount) {
            self = virtualAccountOffline
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid/Unsupported Offsite Payment information")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

public struct BillInformation: Codable {
    let omiseTaxID: String
    let referenceNumber1: String
    let referenceNumber2: String
    let barcodeURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case omiseTaxID = "omise_tax_id"
        case referenceNumber1 = "reference_number_1"
        case referenceNumber2 = "reference_number_2"
        case barcodeURL = "barcode"
    }
}


public struct EnrolledSource: SourceData {
    public typealias Payment = EnrolledSource.SourceType
    
    public enum SourceType: Codable {
        case internetBanking(InternetBanking)
        case alipay
        case billPayment(BillPayment)
        case virtualAccount(VirtualAccount)
        
        public enum BillPayment {
            case tescoLotus(BillInformation)
        }
        
        public enum VirtualAccount {
            case sinarmas(vaCode: String)
            
            fileprivate enum SinarmasCodingKeys: String, CodingKey {
                case vaCode = "va_code"
            }
        }
        
        var type: Omise.SourceType {
            switch self {
            case .internetBanking(let bank):
                return Omise.SourceType.internetBanking(bank)
            case .alipay:
                return Omise.SourceType.alipay
            case .billPayment(let billPayment):
                let bill: Omise.SourceType.BillPayment
                switch billPayment {
                case .tescoLotus:
                    bill = Omise.SourceType.BillPayment.tescoLotus
                }
                return Omise.SourceType.billPayment(bill)
            case .virtualAccount(let account):
                let virtualAccount: Omise.SourceType.VirtualAccount
                switch account {
                case .sinarmas:
                    virtualAccount = Omise.SourceType.VirtualAccount.sinarmas
                }
                return Omise.SourceType.virtualAccount(virtualAccount)
            }
        }
    }
    
    public let id: String
    public let object: String
    
    public let currency: Currency
    public let amount: Int64
    
    public let flow: Flow
    public let type: Payment
    
    private enum CodingKeys: String, CodingKey {
        case id
        case object
        case currency
        case amount
        case flow
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        object = try container.decode(String.self, forKey: .object)
        currency = try container.decode(Currency.self, forKey: .currency)
        amount = try container.decode(Int64.self, forKey: .amount)
        flow = try container.decode(Flow.self, forKey: .flow)
        type = try Payment.init(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(amount, forKey: .amount)
        try container.encode(currency, forKey: .currency)
        try container.encode(amount, forKey: .amount)
        try container.encode(flow, forKey: .flow)
        try type.encode(to: encoder)
    }
}


extension EnrolledSource.SourceType {
    private enum CodingKeys: String, CodingKey {
        case type
        case references
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let typeValue = try container.decode(String.self, forKey: .type)
        
        if typeValue.hasPrefix(internetBankingPrefix),
            let internetBankingOffsite = typeValue
                .range(of: internetBankingPrefix).map({ String(typeValue[$0.upperBound...]) })
                .flatMap(InternetBanking.init(rawValue:)).map(EnrolledSource.SourceType.internetBanking) {
            self = internetBankingOffsite
        } else if typeValue == OffsitePayment.alipayValue {
            self = .alipay
        } else if typeValue.hasPrefix(billPaymentPrefix),
            let billPaymentValue = typeValue
                .range(of: billPaymentPrefix).map({ String(typeValue[$0.upperBound...]) }) {
            switch billPaymentValue {
            case SourceType.BillPayment.tescoLotus.rawValue:
                let billInformation = try container.decode(BillInformation.self, forKey: .references)
                self = .billPayment(.tescoLotus(billInformation))
            default:
                throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid/Unsupported Offsite Payment information")
            }
        } else if typeValue.hasPrefix(virtualAccountPrefix),
            let virtualAccountOffline = typeValue
                .range(of: virtualAccountPrefix).map({ String(typeValue[$0.upperBound...]) }) {
            switch virtualAccountOffline {
            case SourceType.VirtualAccount.sinarmas.rawValue:
                let accountContainer = try container.nestedContainer(keyedBy: EnrolledSource.SourceType.VirtualAccount.SinarmasCodingKeys.self, forKey: .references)
                let vaCode = try accountContainer.decode(String.self, forKey: .vaCode)
                self = .virtualAccount(.sinarmas(vaCode: vaCode))
            default:
                throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid/Unsupported Offsite Payment information")
            }
        } else {
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid/Unsupported Offsite Payment information")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .internetBanking(let bank):
            try container.encode(internetBankingPrefix + bank.rawValue, forKey: .type)
        case .alipay:
            try container.encode(alipayValue, forKey: .type)
            
        case .billPayment(let billPayment):
            switch billPayment {
            case .tescoLotus(let bill):
                try container.encode(billPaymentPrefix + SourceType.BillPayment.tescoLotus.rawValue, forKey: .type)
                try container.encode(bill, forKey: .references)
            }
        case .virtualAccount(let account):
            switch account {
            case .sinarmas(vaCode: let vaCode):
                try container.encode(billPaymentPrefix + SourceType.BillPayment.tescoLotus.rawValue, forKey: .type)
                var accountContainer = container.nestedContainer(keyedBy: EnrolledSource.SourceType.VirtualAccount.SinarmasCodingKeys.self, forKey: .references)
                try accountContainer.encode(vaCode, forKey: .vaCode)
            }
        }
    }
}


public enum Source: SourceData {
    case enrolled(EnrolledSource)
    case source(PaymentSource)
    
    
    public var amount: Int64 {
        switch self {
        case .enrolled(let source):
            return source.amount
        case .source(let source):
            return source.amount
        }
    }
     
    public var currency: Currency {
        switch self {
        case .enrolled(let source):
            return source.currency
        case .source(let source):
            return source.currency
        }
    }
    
    public var flow: Flow {
        switch self {
        case .enrolled(let source):
            return source.flow
        case .source(let source):
            return source.flow
        }
    }
    
    public var type: SourceType {
        switch self {
        case .enrolled(let source):
            return source.type.type
        case .source(let source):
            return source.type
        }
    }
    
    public typealias Payment = SourceType
    
    public var id: String {
        switch self {
        case .enrolled(let source):
            return source.id
        case .source(let source):
            return source.id
        }
    }
    
    public var object: String {
        switch self {
        case .enrolled(let source):
            return source.object
        case .source(let source):
            return source.object
        }
    }
    
    public init(from decoder: Decoder) throws {
        do {
            self = .enrolled(try EnrolledSource.init(from: decoder))
        } catch is DecodingError {
            self = .source(try PaymentSource.init(from: decoder))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .enrolled(let source):
            try source.encode(to: encoder)
        case .source(let source):
            try source.encode(to: encoder)
        }
    }
}




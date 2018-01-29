import Foundation


public enum Flow: String, Codable, Equatable {
    case redirect
    case offline
}


let internetBankingPrefix = "internet_banking_"
let alipayValue = "alipay"
let billPaymentPrefix = "bill_payment_"
let virtualAccountPrefix = "virtual_account_"


public protocol SourceData: OmiseIdentifiableObject {
    associatedtype PaymentInformation: Codable
    
    var amount: Int64 { get }
    var currency: Currency { get }
    
    var flow: Flow { get }
    var paymentInformation: PaymentInformation { get }
    
    var sourceType: SourceType { get }
    
    var value: Value { get }
}

extension SourceData {
    public var value: Value {
        return Value(amount: amount, currency: currency)
    }
}


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
            
        case (.unknown(let lhsSource), .unknown(let rhsSource)):
            return lhsSource == rhsSource
            
        default:
            return false
        }
    }
}


public struct PaymentSource: SourceData {
    public typealias PaymentInformation = SourceType
    
    public let id: String
    public let object: String
    
    public let currency: Currency
    public let amount: Int64
    
    public let flow: Flow
    public let paymentInformation: SourceType
    
    public var sourceType: SourceType {
        return paymentInformation
    }
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
        
        id = try container.decode(String.self, forKey: .id)
        object = try container.decode(String.self, forKey: .object)
        currency = try container.decode(Currency.self, forKey: .currency)
        amount = try container.decode(Int64.self, forKey: .amount)
        flow = try container.decode(Flow.self, forKey: .flow)
        paymentInformation = try container.decode(SourceType.self, forKey: .type)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(amount, forKey: .amount)
        try container.encode(currency, forKey: .currency)
        try container.encode(amount, forKey: .amount)
        try container.encode(flow, forKey: .flow)
        try container.encode(paymentInformation, forKey: .type)
    }
}


extension SourceType {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let value = try container.decode(String.self)
        if value.hasPrefix(internetBankingPrefix),
            let internetBankingOffsite = value
                .range(of: internetBankingPrefix).map({ String(value[$0.upperBound...]) })
                .flatMap(InternetBanking.init(rawValue:)).map(PaymentSource.PaymentInformation.internetBanking) {
            self = internetBankingOffsite
        } else if value == alipayValue {
            self = .alipay
        } else if value.hasPrefix(billPaymentPrefix),
            let billPaymentOffline = value
                .range(of: billPaymentPrefix).map({ String(value[$0.upperBound...]) })
                .flatMap(PaymentSource.PaymentInformation.BillPayment.init(rawValue:)).map(PaymentSource.PaymentInformation.billPayment) {
            self = billPaymentOffline
        } else if value.hasPrefix(virtualAccountPrefix),
            let virtualAccountOffline = value
                .range(of: virtualAccountPrefix).map({ String(value[$0.upperBound...]) })
                .flatMap(PaymentSource.PaymentInformation.VirtualAccount.init(rawValue:)).map(PaymentSource.PaymentInformation.virtualAccount) {
            self = virtualAccountOffline
        } else {
            self = .unknown(value)
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
    public typealias PaymentInformation = EnrolledSource.EnrolledPaymentInformation
    
    public enum EnrolledPaymentInformation: Codable {
        case internetBanking(InternetBanking)
        case alipay
        case billPayment(BillPayment)
        case virtualAccount(VirtualAccount)
        
        case unknown(name: String, references: [String: Any]?)
        
        public enum BillPayment {
            case tescoLotus(BillInformation)
            case unknown(name: String, references: [String: Any])
        }
        
        public enum VirtualAccount {
            case sinarmas(vaCode: String)
            case unknown(name: String, references: [String: Any])
            
            fileprivate enum SinarmasCodingKeys: String, CodingKey {
                case vaCode = "va_code"
            }
        }
        
        var sourceType: Omise.SourceType {
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
                case .unknown(let name, _):
                    bill = Omise.SourceType.BillPayment.unknown(name)
                }
                return Omise.SourceType.billPayment(bill)
            case .virtualAccount(let account):
                let virtualAccount: Omise.SourceType.VirtualAccount
                switch account {
                case .sinarmas:
                    virtualAccount = Omise.SourceType.VirtualAccount.sinarmas
                case .unknown(let name, _):
                    virtualAccount = Omise.SourceType.VirtualAccount.unknown(name)
                }
                return Omise.SourceType.virtualAccount(virtualAccount)
            case .unknown(name: let sourceName, references: _):
                return Omise.SourceType.unknown(sourceName)
            }
        }
    }
    
    public let id: String
    public let object: String
    
    public let currency: Currency
    public let amount: Int64
    
    public let flow: Flow
    public let paymentInformation: PaymentInformation
    
    public var sourceType: SourceType {
        return paymentInformation.sourceType
    }
    
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
        paymentInformation = try PaymentInformation.init(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(object, forKey: .object)
        try container.encode(id, forKey: .id)
        try container.encode(currency, forKey: .currency)
        try container.encode(amount, forKey: .amount)
        try container.encode(flow, forKey: .flow)
        try paymentInformation.encode(to: encoder)
    }
}


extension EnrolledSource.EnrolledPaymentInformation {
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
                .flatMap(InternetBanking.init(rawValue:)).map(EnrolledSource.PaymentInformation.internetBanking) {
            self = internetBankingOffsite
        } else if typeValue == alipayValue {
            self = .alipay
        } else if typeValue.hasPrefix(billPaymentPrefix),
            let billPaymentValue = typeValue
                .range(of: billPaymentPrefix).map({ String(typeValue[$0.upperBound...]) }) {
            switch billPaymentValue {
            case SourceType.BillPayment.tescoLotus.rawValue:
                let billInformation = try container.decode(BillInformation.self, forKey: .references)
                self = .billPayment(.tescoLotus(billInformation))
            case let billPaymentType:
                let references = try container.decode(Dictionary<String, Any>.self, forKey: .references)
                self = .billPayment(.unknown(name: billPaymentType, references: references))
            }
        } else if typeValue.hasPrefix(virtualAccountPrefix),
            let virtualAccountOffline = typeValue
                .range(of: virtualAccountPrefix).map({ String(typeValue[$0.upperBound...]) }) {
            switch virtualAccountOffline {
            case SourceType.VirtualAccount.sinarmas.rawValue:
                let accountContainer = try container.nestedContainer(keyedBy: EnrolledSource.PaymentInformation.VirtualAccount.SinarmasCodingKeys.self, forKey: .references)
                let vaCode = try accountContainer.decode(String.self, forKey: .vaCode)
                self = .virtualAccount(.sinarmas(vaCode: vaCode))
            case let virtualAccountType:
                let references = try container.decode(Dictionary<String, Any>.self, forKey: .references)
                self = .virtualAccount(.unknown(name: virtualAccountType, references: references))
            }
        } else {
            let references = try container.decodeIfPresent(Dictionary<String, Any>.self, forKey: .references)
            self = .unknown(name: typeValue, references: references)
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
            case let .unknown(name: name, references: references):
                try container.encode(billPaymentPrefix + name, forKey: .type)
                try container.encode(references, forKey: .references)
            }
        case .virtualAccount(let account):
            switch account {
            case .sinarmas(vaCode: let vaCode):
                try container.encode(virtualAccountPrefix + SourceType.VirtualAccount.sinarmas.rawValue, forKey: .type)
                var accountContainer = container.nestedContainer(keyedBy: EnrolledSource.PaymentInformation.VirtualAccount.SinarmasCodingKeys.self, forKey: .references)
                try accountContainer.encode(vaCode, forKey: .vaCode)
            case let .unknown(name: name, references: references):
                try container.encode(virtualAccountPrefix + name, forKey: .type)
                try container.encode(references, forKey: .references)
            }
        case .unknown(name: let sourceType, references: let references):
            try container.encode(sourceType, forKey: .type)
            try container.encodeIfPresent(references, forKey: .references)
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
    
    public var paymentInformation: SourceType {
        switch self {
        case .enrolled(let source):
            return source.paymentInformation.sourceType
        case .source(let source):
            return source.paymentInformation
        }
    }
    
    public var sourceType: SourceType {
        return paymentInformation
    }
    
    public typealias PaymentInformation = SourceType
    
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


public struct PaymentSourceParams: APIJSONQuery {
    public let amount: Int64
    public let currency: Currency
    public let type: SourceType
}

extension PaymentSource: Creatable {
    public typealias CreateParams = PaymentSourceParams
    
    public typealias CreateEndpoint = APIEndpoint<PaymentSource>
    public typealias CreateRequest = APIRequest<PaymentSource>

    public static func createEndpointWith(params: CreateParams) -> CreateEndpoint {
        return CreateEndpoint(
            pathComponents: ["sources"],
            parameter: .post(params)
        )
    }
    
    public static func create(using client: APIClient, params: CreateParams, callback: @escaping CreateRequest.Callback) -> CreateRequest? {
        let endpoint = self.createEndpointWith(params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}



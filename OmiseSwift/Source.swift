import Foundation


public enum Flow: String, Codable, Equatable {
    case redirect
    case offline
}


public protocol SourceData: OmiseIdentifiableObject {
    associatedtype PaymentInformation: Codable, Equatable
    
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
            return source.paymentInformation.sourceType
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


public enum PaymentSourceInformation: Codable, Equatable {
    case internetBanking(InternetBanking)
    case alipay
    case billPayment(SourceType.BillPayment)
    case virtualAccount(SourceType.VirtualAccount)
    case wallet(Wallet)
    
    case unknown(String)
    
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
            case .unknown(let name):
                bill = Omise.SourceType.BillPayment.unknown(name)
            }
            return Omise.SourceType.billPayment(bill)
        case .virtualAccount(let account):
            let virtualAccount: Omise.SourceType.VirtualAccount
            switch account {
            case .sinarmas:
                virtualAccount = Omise.SourceType.VirtualAccount.sinarmas
            case .unknown(let name):
                virtualAccount = Omise.SourceType.VirtualAccount.unknown(name)
            }
            return Omise.SourceType.virtualAccount(virtualAccount)
        case .wallet(let walletInformation):
            let wallet: Omise.SourceType.Wallet
            switch walletInformation {
            case .alipay:
                wallet = .alipay
            case .unknown(let name, _):
                wallet = .unknown(name)
            }
            return .wallet(wallet)
        case .unknown(name: let sourceName):
            return Omise.SourceType.unknown(sourceName)
        }
    }
    
    var value: String {
        return sourceType.value
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeValue = try container.decode(String.self, forKey: .type)
        
        if typeValue.hasPrefix(internetBankingPrefix),
            let internetBankingOffsite = typeValue
                .range(of: internetBankingPrefix).map({ String(typeValue[$0.upperBound...]) })
                .flatMap(InternetBanking.init(rawValue:)).map(PaymentSourceInformation.internetBanking) {
            self = internetBankingOffsite
        } else if typeValue == alipayValue {
            self = .alipay
        } else if typeValue.hasPrefix(billPaymentPrefix),
            let billPaymentOffline = typeValue
                .range(of: billPaymentPrefix).map({ String(typeValue[$0.upperBound...]) })
                .flatMap(SourceType.BillPayment.init(rawValue:)).map(PaymentSourceInformation.billPayment) {
            self = billPaymentOffline
        } else if typeValue.hasPrefix(virtualAccountPrefix),
            let virtualAccountOffline = typeValue
                .range(of: virtualAccountPrefix).map({ String(typeValue[$0.upperBound...]) })
                .flatMap(SourceType.VirtualAccount.init(rawValue:)).map(PaymentSourceInformation.virtualAccount) {
            self = virtualAccountOffline
        } else if typeValue.hasPrefix(walletPrefix),
            let walletValue = typeValue
                .range(of: walletPrefix).map({ String(typeValue[$0.upperBound...]) }) {
            switch walletValue {
            case SourceType.Wallet.alipay.rawValue:
                let alipayWallet = try Wallet.AlipayWallet.init(from: decoder)
                self = .wallet(.alipay(alipayWallet))
            case let walletType:
                let parameters = try decoder.decodeJSONDictionary().filter({ (key, _) -> Bool in
                    switch key {
                    case PaymentSource.CodingKeys.id.stringValue,
                         PaymentSource.CodingKeys.object.stringValue,
                         PaymentSource.CodingKeys.isLive.stringValue,
                         PaymentSource.CodingKeys.location.stringValue,
                         PaymentSource.CodingKeys.currency.stringValue,
                         PaymentSource.CodingKeys.amount.stringValue,
                         PaymentSource.CodingKeys.flow.stringValue,
                         PaymentSource.CodingKeys.type.stringValue:
                        return false
                    default: return true
                    }
                })
                self = .wallet(.unknown(name: walletType, parameters: parameters))
            }
        } else {
            self = .unknown(typeValue)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .type)
        
        if case .wallet(let walletInformation) = self {
            try walletInformation.encode(to: encoder)
        }
    }
    
    public static func ==(lhs: PaymentSourceInformation, rhs: PaymentSourceInformation) -> Bool {
        switch (lhs, rhs) {
        case (.internetBanking(let lhsValue), .internetBanking(let rhsValue)):
            return lhsValue == rhsValue
        case (.alipay, .alipay):
            return true
        case (.billPayment(let lhsValue), .billPayment(let rhsValue)):
            return lhsValue == rhsValue
        case (.virtualAccount(let lhsValue), .virtualAccount(let rhsValue)):
            return lhsValue == rhsValue
        case (.wallet(let lhsValue), .wallet(let rhsValue)):
            return lhsValue == rhsValue
        default: return false
        }
    }
}

public struct PaymentSource: SourceData, OmiseLocatableObject, OmiseIdentifiableObject, OmiseLiveModeObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(parentType: nil, path: "sources")
    public typealias PaymentInformation = PaymentSourceInformation
    
    public let id: String
    public let object: String
    public let isLive: Bool
    public let location: String
    
    public let currency: Currency
    public let amount: Int64
    
    public let flow: Flow
    public let paymentInformation: PaymentSourceInformation
    
    public var sourceType: SourceType {
        return paymentInformation.sourceType
    }
}

extension PaymentSource {
    fileprivate enum CodingKeys: String, CodingKey {
        case id
        case object
        case isLive = "livemode"
        case location
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
        isLive = try container.decode(Bool.self, forKey: .isLive)
        location = try container.decode(String.self, forKey: .location)
        currency = try container.decode(Currency.self, forKey: .currency)
        amount = try container.decode(Int64.self, forKey: .amount)
        flow = try container.decode(Flow.self, forKey: .flow)
        paymentInformation = try PaymentSourceInformation(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(object, forKey: .object)
        try container.encode(isLive, forKey: .isLive)
        try container.encode(location, forKey: .location)
        try container.encode(amount, forKey: .amount)
        try container.encode(currency, forKey: .currency)
        try container.encode(flow, forKey: .flow)
        try paymentInformation.encode(to: encoder)
    }
}


public enum Wallet: Codable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeValue = try container.decode(String.self, forKey: .type)
        switch typeValue {
        case SourceType.Wallet.alipay.rawValue:
            let alipayWallet = try AlipayWallet(from: decoder)
            self = .alipay(alipayWallet)
        case let value:
            let parameters = try decoder.decodeJSONDictionary().filter({ $0.key != "type" })
            self = .unknown(name: value, parameters: parameters)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .alipay(let walletInformation):
            try walletInformation.encode(to: encoder)
        case .unknown(name: _, parameters: let parameters):
            try encoder.encodeJSONDictionary(parameters.filter({ $0.key != "type" }))
        }
    }
    
    case alipay(AlipayWallet)
    case unknown(name: String, parameters: [String: Any])
    
    var value: String {
        let value: String
        switch self {
        case .alipay:
            value = "alipay"
        case .unknown(name: let name, parameters: _):
            value = name
        }
        return value
    }
    
    public struct AlipayWallet: Codable, Equatable {
        public let barcode: String
        public let storeID: String
        public let storeName: String
        public let terminalID: String?
        private enum CodingKeys: String, CodingKey {
            case barcode
            case storeID = "store_id"
            case storeName = "store_name"
            case terminalID = "terminal_id"
        }
        
        public static func ==(lhs: Wallet.AlipayWallet, rhs: Wallet.AlipayWallet) -> Bool {
            return lhs.barcode == rhs.barcode && lhs.storeID == rhs.storeID &&
                lhs.storeName == rhs.storeName && lhs.terminalID == rhs.terminalID
        }
    }
    
    public static func ==(lhs: Wallet, rhs: Wallet) -> Bool {
        switch (lhs, rhs) {
        case (.alipay(let lhsValue), .alipay(let rhsValue)):
            return lhsValue == rhsValue
        case let (.unknown(name: lhsName, parameters: _), .unknown(name: rhsName, parameters: _)):
            return lhsName == rhsName
        default: return false
        }
    }
}


public struct EnrolledSource: SourceData {
    public typealias PaymentInformation = EnrolledSource.EnrolledPaymentInformation
    
    public enum EnrolledPaymentInformation: Codable, Equatable {
        case internetBanking(InternetBanking)
        case alipay
        case billPayment(BillPayment)
        case virtualAccount(VirtualAccount)
        case wallet(Wallet)
        
        case unknown(name: String, references: [String: Any]?)
        
        public enum BillPayment: Equatable {
            
            case tescoLotus(BillInformation)
            case unknown(name: String, references: [String: Any])
            
            public struct BillInformation: Codable, Equatable {
                let omiseTaxID: String
                let referenceNumber1: String
                let referenceNumber2: String
                let barcodeURL: URL
                let expired: Date
                
                private enum CodingKeys: String, CodingKey {
                    case omiseTaxID = "omise_tax_id"
                    case referenceNumber1 = "reference_number_1"
                    case referenceNumber2 = "reference_number_2"
                    case barcodeURL = "barcode"
                    case expired = "expires_at"
                }
                
                public static func ==(lhs: BillInformation, rhs: BillInformation) -> Bool {
                    return lhs.omiseTaxID == rhs.omiseTaxID && lhs.referenceNumber1 == rhs.referenceNumber1 &&
                        lhs.referenceNumber2 == rhs.referenceNumber2 && lhs.barcodeURL == rhs.barcodeURL
                }
            }
            
            public static func ==(lhs: BillPayment, rhs: BillPayment) -> Bool {
                switch (lhs, rhs) {
                case let (.tescoLotus(lhsValue), .tescoLotus(rhsValue)):
                    return lhsValue == rhsValue
                case let (.unknown(name: lhsName, references: _), .unknown(name: rhsName, references: _)):
                    return lhsName == rhsName
                default: return false
                }
            }
        }
        
        public enum VirtualAccount: Equatable {
            case sinarmas(vaCode: String)
            case unknown(name: String, references: [String: Any])
            
            fileprivate enum SinarmasCodingKeys: String, CodingKey {
                case vaCode = "va_code"
            }
            
            public static func ==(lhs: EnrolledSource.EnrolledPaymentInformation.VirtualAccount, rhs: EnrolledSource.EnrolledPaymentInformation.VirtualAccount) -> Bool {
                switch (lhs, rhs) {
                case let (.sinarmas(lhsValue), .sinarmas(rhsValue)):
                    return lhsValue == rhsValue
                case let (.unknown(name: lhsName, references: _), .unknown(name: rhsName, references: _)):
                    return lhsName == rhsName
                default: return false
                }
            }
        }
        
        public enum Wallet: Equatable {
            case alipay(AlipayWallet)
            case unknown(name: String, references: [String: Any])
            
            var value: String {
                let value: String
                switch self {
                case .alipay:
                    value = "alipay"
                case .unknown(name: let name, references: _):
                    value = name
                }
                return value
            }
            
            public struct AlipayWallet: Codable {
                public let expired: Date
                fileprivate enum CodingKeys: String, CodingKey {
                    case expired = "expires_at"
                }
            }
            
            public static func ==(lhs: EnrolledSource.EnrolledPaymentInformation.Wallet, rhs: EnrolledSource.EnrolledPaymentInformation.Wallet) -> Bool {
                switch (lhs, rhs) {
                case (.alipay, .alipay):
                    return true
                case let (.unknown(name: lhsName, references: _), .unknown(name: rhsName, references: _)):
                    return lhsName == rhsName
                default: return false
                }
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
            case .wallet(let walletInformation):
                let wallet: Omise.SourceType.Wallet
                switch walletInformation {
                case .alipay:
                    wallet = .alipay
                case .unknown(name: let name, references: _):
                    wallet = .unknown(name)
                }
                return .wallet(wallet)
            case .unknown(name: let sourceName, references: _):
                return Omise.SourceType.unknown(sourceName)
            }
        }
        
        public static func ==(lhs: EnrolledSource.EnrolledPaymentInformation, rhs: EnrolledSource.EnrolledPaymentInformation) -> Bool {
            switch (lhs, rhs) {
            case (.internetBanking(let lhsValue), .internetBanking(let rhsValue)):
                return lhsValue == rhsValue
            case (.alipay, .alipay):
                return true
            case (.billPayment(let lhsValue), .billPayment(let rhsValue)):
                return lhsValue == rhsValue
            case (.virtualAccount(let lhsValue), .virtualAccount(let rhsValue)):
                return lhsValue == rhsValue
            case (.wallet(let lhsValue), .wallet(let rhsValue)):
                return lhsValue == rhsValue
            default: return false
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
                let billInformation = try container.decode(BillPayment.BillInformation.self, forKey: .references)
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
        } else if typeValue.hasPrefix(walletPrefix),
            let walletValue = typeValue
                .range(of: walletPrefix).map({ String(typeValue[$0.upperBound...]) }) {
            switch walletValue {
            case SourceType.Wallet.alipay.rawValue:
                let alipayWallet = try container.decode(Wallet.AlipayWallet.self, forKey: .references)
                self = .wallet(.alipay(alipayWallet))
            case let walletType:
                let references = try container.decode(Dictionary<String, Any>.self, forKey: .references)
                self = .wallet(.unknown(name: walletType, references: references))
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
        case .wallet(let wallet):
            switch wallet {
            case .alipay(let alipayWallet):
                try container.encode(walletPrefix + SourceType.Wallet.alipay.rawValue, forKey: .type)
                try container.encode(alipayWallet, forKey: .references)
            case let .unknown(name: name, references: references):
                try container.encode(walletPrefix + name, forKey: .type)
                try container.encode(references, forKey: .references)
            }
        case .unknown(name: let sourceType, references: let references):
            try container.encode(sourceType, forKey: .type)
            try container.encodeIfPresent(references, forKey: .references)
        }
    }
}


public typealias AlipayWalletParams = Wallet.AlipayWallet

public struct PaymentSourceParams: APIJSONQuery {
    public let amount: Int64
    public let currency: Currency
    
    public let type: PaymentSourceInformation
    
    private enum CodingKeys: String, CodingKey {
        case amount
        case currency
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount, forKey: .amount)
        try container.encode(currency, forKey: .currency)
        
        try type.encode(to: encoder)
    }
}

extension PaymentSource: Retrievable {}

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



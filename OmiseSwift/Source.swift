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
    case barcode(Barcode)
    
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
        case .barcode(let barcodeInformation):
            let barcode: Omise.SourceType.Barcode
            switch barcodeInformation {
            case .alipay:
                barcode = .alipay
            case .unknown(let name, _):
                barcode = .unknown(name)
            }
            return .barcode(barcode)
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
        } else if typeValue.hasPrefix(barcodePrefix),
            let barcodeValue = typeValue
                .range(of: barcodePrefix).map({ String(typeValue[$0.upperBound...]) }) {
            switch barcodeValue {
            case SourceType.Barcode.alipay.rawValue:
                let alipayBarcode = try Barcode.AlipayBarcode.init(from: decoder)
                self = .barcode(.alipay(alipayBarcode))
            case let barcodeType:
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
                self = .barcode(.unknown(name: barcodeType, parameters: parameters))
            }
        } else {
            self = .unknown(typeValue)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .type)
        
        if case .barcode(let barcodeInformation) = self {
            try barcodeInformation.encode(to: encoder)
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


public enum Barcode: Codable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeValue = try container.decode(String.self, forKey: .type)
        switch typeValue {
        case SourceType.Barcode.alipay.rawValue:
            let alipayBarcode = try AlipayBarcode(from: decoder)
            self = .alipay(alipayBarcode)
        case let value:
            let parameters = try decoder.decodeJSONDictionary().filter({ $0.key != "type" })
            self = .unknown(name: value, parameters: parameters)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .alipay(let barcodeInformation):
            try barcodeInformation.encode(to: encoder)
        case .unknown(name: _, parameters: let parameters):
            try encoder.encodeJSONDictionary(parameters.filter({ $0.key != "type" }))
        }
    }
    
    case alipay(AlipayBarcode)
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
    
    public struct AlipayBarcode: Codable, Equatable {
        public let barcode: String
        
        public struct StoreInformation: Codable, Equatable {
            public let storeID: String
            public let storeName: String
            
            public init(storeID: String, storeName: String) {
                self.storeID = storeID
                self.storeName = storeName
            }
        }
        
        public let storeInformation: StoreInformation?
        
        public var storeID: String? {
            return storeInformation?.storeID
        }
        
        public var storeName: String? {
            return storeInformation?.storeName
        }
        
        public let terminalID: String?
        private enum CodingKeys: String, CodingKey {
            case barcode
            case storeID = "store_id"
            case storeName = "store_name"
            case terminalID = "terminal_id"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let barcode = try container.decode(String.self, forKey: .barcode)

            let storeID = try container.decodeIfPresent(String.self, forKey: .storeID)
            let storeName = try container.decodeIfPresent(String.self, forKey: .storeName)
            
            let terminalID = try container.decodeIfPresent(String.self, forKey: .terminalID)
            
            let storeInformation: StoreInformation?
            switch (storeID, storeName) {
            case let (storeID?, storeName?):
                storeInformation = StoreInformation(storeID: storeID, storeName: storeName)
            case (nil, nil):
                storeInformation = nil
            case (nil, .some):
                throw DecodingError.keyNotFound(CodingKeys.storeID, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Alipay Barcode store name is present but store id informaiton is missing"))
            case (.some, nil):
                throw DecodingError.keyNotFound(CodingKeys.storeName, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Alipay Barcode store id is present but store name informaiton is missing"))
            }
            
            self.init(storeInformation: storeInformation, terminalID: terminalID, barcode: barcode)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(barcode, forKey: .barcode)
            
            try container.encodeIfPresent(storeInformation?.storeID, forKey: .storeID)
            try container.encodeIfPresent(storeInformation?.storeName, forKey: .storeName)
            try container.encodeIfPresent(terminalID, forKey: .terminalID)
        }
        
        public init(storeInformation: StoreInformation?, terminalID: String?, barcode: String) {
            self.storeInformation = storeInformation
            self.terminalID = terminalID
            self.barcode = barcode
        }
        
        public init(storeID: String, storeName: String, terminalID: String?, barcode: String) {
            self.init(storeInformation: StoreInformation(storeID: storeID, storeName: storeName), terminalID: terminalID, barcode: barcode)
        }
        
        public init(terminalID: String?, barcode: String) {
            self.init(storeInformation: nil, terminalID: terminalID, barcode: barcode)
        }
    }
    
    public static func ==(lhs: Barcode, rhs: Barcode) -> Bool {
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
        case barcode(Barcode)
        
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
        
        public enum Barcode: Equatable {
            case alipay(AlipayBarcode)
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
            
            public struct AlipayBarcode: Codable {
                public let expired: Date
                fileprivate enum CodingKeys: String, CodingKey {
                    case expired = "expires_at"
                }
            }
            
            public static func ==(lhs: EnrolledSource.EnrolledPaymentInformation.Barcode, rhs: EnrolledSource.EnrolledPaymentInformation.Barcode) -> Bool {
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
            case .barcode(let barcodeInformation):
                let barcode: Omise.SourceType.Barcode
                switch barcodeInformation {
                case .alipay:
                    barcode = .alipay
                case .unknown(name: let name, references: _):
                    barcode = .unknown(name)
                }
                return .barcode(barcode)
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
            case (.barcode(let lhsValue), .barcode(let rhsValue)):
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
        } else if typeValue.hasPrefix(barcodePrefix),
            let barcodeValue = typeValue
                .range(of: barcodePrefix).map({ String(typeValue[$0.upperBound...]) }) {
            switch barcodeValue {
            case SourceType.Barcode.alipay.rawValue:
                let alipayBarcode = try container.decode(Barcode.AlipayBarcode.self, forKey: .references)
                self = .barcode(.alipay(alipayBarcode))
            case let barcodeType:
                let references = try container.decode(Dictionary<String, Any>.self, forKey: .references)
                self = .barcode(.unknown(name: barcodeType, references: references))
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
        case .barcode(let barcode):
            switch barcode {
            case .alipay(let alipayBarcode):
                try container.encode(barcodePrefix + SourceType.Barcode.alipay.rawValue, forKey: .type)
                try container.encode(alipayBarcode, forKey: .references)
            case let .unknown(name: name, references: references):
                try container.encode(barcodePrefix + name, forKey: .type)
                try container.encode(references, forKey: .references)
            }
        case .unknown(name: let sourceType, references: let references):
            try container.encode(sourceType, forKey: .type)
            try container.encodeIfPresent(references, forKey: .references)
        }
    }
}


public typealias AlipayBarcodeParams = Barcode.AlipayBarcode

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
    
    public init(amount: Int64, currency: Currency, type: PaymentSourceInformation) {
        self.amount = amount
        self.currency = currency
        self.type = type
    }
    
    public init(value: Value, type: PaymentSourceInformation) {
        self.amount = value.amount
        self.currency = value.currency
        self.type = type
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



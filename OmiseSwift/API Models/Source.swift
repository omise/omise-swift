import Foundation


public enum Flow: String, Codable, Equatable {
    case redirect
    case offline
    case appRedirect = "app_redirect"
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
    public static let idPrefix: String = "src"
    
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
    
    public var id: DataID<Source> {
        switch self {
        case .enrolled(let source):
            return DataID<Source>(idString: source.id.idString)!
        case .source(let source):
            return DataID<Source>(idString: source.id.idString)!
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
    
}

extension Source {
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


public enum Barcode: Codable, Equatable {
    case alipay(AlipayBarcode)
    case weChatPay(WeChatPayBarcode)
    case unknown(name: String, parameters: [String: Any])
    
    var value: String {
        let value: String
        switch self {
        case .alipay:
            value = "alipay"
        case .weChatPay:
            value = "wechat"
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
                throw DecodingError.keyNotFound(
                    CodingKeys.storeID,
                    DecodingError.Context(
                        codingPath: container.codingPath,
                        debugDescription: "Alipay Barcode store name is present but store id informaiton is missing"))
            case (.some, nil):
                throw DecodingError.keyNotFound(
                    CodingKeys.storeName,
                    DecodingError.Context(
                        codingPath: container.codingPath,
                        debugDescription: "Alipay Barcode store id is present but store name information is missing"))
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
            self.init(
                storeInformation: StoreInformation(storeID: storeID, storeName: storeName),
                terminalID: terminalID, barcode: barcode)
        }
        
        public init(terminalID: String?, barcode: String) {
            self.init(storeInformation: nil, terminalID: terminalID, barcode: barcode)
        }
    }

    public struct WeChatPayBarcode: Codable, Equatable {
        public let barcode: String
        
        public init(barcode: String) {
            self.barcode = barcode
        }
    }
    
    public static func ==(lhs: Barcode, rhs: Barcode) -> Bool {
        switch (lhs, rhs) {
        case (.alipay(let lhsValue), .alipay(let rhsValue)):
            return lhsValue == rhsValue
        case (.weChatPay(let lhsValue), .weChatPay(let rhsValue)):
            return lhsValue == rhsValue
        case let (.unknown(name: lhsName, parameters: _), .unknown(name: rhsName, parameters: _)):
            return lhsName == rhsName
        default: return false
        }
    }
    
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
        case SourceType.Barcode.weChatPay.rawValue:
            let weChatPayBarcode = try WeChatPayBarcode(from: decoder)
            self = .weChatPay(weChatPayBarcode)
        case let value:
            let parameters = try decoder.decode(as: Dictionary<String, Any>.self, skippingKeys: CodingKeys.self)
            self = .unknown(name: value, parameters: parameters)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .alipay(let barcodeInformation):
            try barcodeInformation.encode(to: encoder)
        case .weChatPay(let barcodeInformation):
            try barcodeInformation.encode(to: encoder)
        case .unknown(name: _, parameters: let parameters):
            try encoder.encode(parameters, skippingKeysBy: CodingKeys.self)
        }
    }
    
}


public struct Installment: Codable, Equatable {
    /// The brand of the bank of the installment
    public let brand: SourceType.InstallmentBrand
    /// A number of terms to do the installment
    public let numberOfTerms: Int
    
    public let isZeroInterests: Bool
    
    fileprivate enum CodingKeys: String, CodingKey {
        case type
        case isZeroInterests = "zero_interest_installments"
        case installmentTerms = "installment_term"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let typeValue = try container.decode(String.self, forKey: .type)
        
        guard typeValue.hasPrefix(installmentPrefix),
            let installmentBrand = typeValue
                .range(of: installmentPrefix)
                .map({ String(typeValue[$0.upperBound...]) })
                .flatMap(SourceType.InstallmentBrand.init(rawValue:)) else {
                    throw DecodingError.dataCorruptedError(
                        forKey: CodingKeys.type, in: container,
                        debugDescription: "Invalid Installment Source Type value")
        }
        
        self.brand = installmentBrand
        self.numberOfTerms = try container.decode(Int.self, forKey: .installmentTerms)
        self.isZeroInterests = try container.decode(Bool.self, forKey: .isZeroInterests)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(installmentPrefix + brand.rawValue, forKey: .type)
        try container.encode(numberOfTerms, forKey: .installmentTerms)
        try container.encode(isZeroInterests, forKey: .isZeroInterests)
    }
    
    
    public static func availableTerms(for brand: SourceType.InstallmentBrand) -> IndexSet {
        switch brand {
        case .bay:
            return IndexSet([ 3, 4, 6, 9, 10 ])
        case .firstChoice:
            return IndexSet([ 3, 4, 6, 9, 10, 12, 18, 24, 36 ])
        case .bbl:
            return IndexSet([ 4, 6, 8, 9, 10 ])
        case .ktc:
            return IndexSet([ 3, 4, 5, 6, 7, 8, 9, 10 ])
        case .kBank:
            return IndexSet([ 3, 4, 6, 10 ])
        case .scb:
            return IndexSet([ 3, 4, 6, 9, 10 ])
        case .unknown:
            return IndexSet(1...360) // We don't have the availabe terms for those unknown brand but we think 30 years should be enough
        }
    }
    
    public struct CreateParameter: Codable, Equatable {
        public let brand: SourceType.InstallmentBrand
        public let numberOfTerms: Int
        
        private enum CodingKeys: String, CodingKey {
            case brand
            case numberOfTerms = "installment_term"
        }
        
        public init(brand: SourceType.InstallmentBrand, numberOfTerms: Int) {
            self.brand = brand
            self.numberOfTerms = numberOfTerms
        }
    }
}

public typealias AlipayBarcodeParams = Barcode.AlipayBarcode
public typealias WeChatPayBarcodeParams = Barcode.WeChatPayBarcode

public struct PaymentSourceParams: APIJSONQuery {
    public let amount: Int64
    public let currency: Currency
    
    public let sourceParameter: SourceParameter
    
    public enum SourceParameter: Encodable, Equatable {
        case internetBanking(InternetBanking)
        case alipay
        case billPayment(SourceType.BillPayment)
        case barcode(Barcode)
        case installment(Installment.CreateParameter)
        case promptPay
        case payNow
        case mobileBanking(MobileBanking)
        case fpx(FPXBank)

        case unknown(String)
        
        var sourceType: Omise.SourceType {
            switch self {
            case .internetBanking(let bank):
                return Omise.SourceType.internetBanking(bank)
            case .mobileBanking(let bank):
                return Omise.SourceType.mobileBanking(bank)
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
            case .barcode(let barcodeInformation):
                let barcode: Omise.SourceType.Barcode
                switch barcodeInformation {
                case .alipay:
                    barcode = .alipay
                case .weChatPay:
                    barcode = .weChatPay
                case .unknown(let name, _):
                    barcode = .unknown(name)
                }
                return .barcode(barcode)
                
            case .installment(let installment):
                return .installment(installment.brand)
            case .promptPay:
                return .promptPay
            case .payNow:
                return .payNow
            case .fpx(let fpxBank):
                return .fpx(fpxBank)
            case .unknown(name: let sourceName):
                return Omise.SourceType.unknown(sourceName)
            }
        }
        
        
        private enum CodingKeys: String, CodingKey {
            case type
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(sourceType.value, forKey: .type)
            
            switch self {
            case .barcode(let barcodeInformation):
                try barcodeInformation.encode(to: encoder)
            case .installment(let parameter):
                try parameter.encode(to: encoder)
            default: break
            }
        }
    }
    
    
    private enum CodingKeys: String, CodingKey {
        case amount
        case currency
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount, forKey: .amount)
        try container.encode(currency, forKey: .currency)
        
        try sourceParameter.encode(to: encoder)
    }
    
    public init(amount: Int64, currency: Currency, type: SourceParameter) {
        self.amount = amount
        self.currency = currency
        self.sourceParameter = type
    }
    
    public init(value: Value, type: SourceParameter) {
        self.amount = value.amount
        self.currency = value.currency
        self.sourceParameter = type
    }
}


extension PaymentSource: OmiseAPIPrimaryObject {}
extension PaymentSource: Retrievable {}

extension PaymentSource: Creatable {
    public typealias CreateParams = PaymentSourceParams
    
    public typealias CreateEndpoint = APIEndpoint<CreateParams, PaymentSource>
    public typealias CreateRequest = APIRequest<CreateParams, PaymentSource>
    
    public static func createEndpoint(with params: CreateParams) -> CreateEndpoint {
        return CreateEndpoint(
            pathComponents: ["sources"],
            method: .post, query: params)
    }
    
    public static func create(
        using client: APIClient, params: CreateParams, 
        callback: @escaping CreateRequest.Callback
        ) -> CreateRequest? {
        let endpoint = self.createEndpoint(with: params)
        return client.request(to: endpoint, callback: callback)
    }
}



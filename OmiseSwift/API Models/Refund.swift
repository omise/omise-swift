import Foundation


public struct Refund: OmiseResourceObject, Equatable {
    public static let resourcePath = "/refunds"
    public static let idPrefix: String = "rfnd"
    
    public let object: String
    public let location: String
    public let isLiveMode: Bool
    
    public let id: DataID<Refund>
    public let createdDate: Date
    
    public let status: Status
    
    public var value: Value {
        return Value(amount: amount, currency: currency)
    }
    
    public let amount: Int64
    public let currency: Currency
    
    public let fundingAmount: Int64
    public let fundingCurrency: Currency
    public var fundingValue: Value {
        return Value(amount: fundingAmount, currency: fundingCurrency)
    }
    
    public let isVoided: Bool
    
    public let charge: DetailProperty<Charge>
    public let transaction: DetailProperty<Transaction<Refund>>
    
    public let metadata: JSONDictionary
    
    public enum Status: String, Codable {
        case pending
        case closed
    }
}

extension Refund {
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case createdDate = "created_at"
        case isLiveMode = "livemode"
        case status
        case amount
        case currency
        case fundingAmount = "funding_amount"
        case fundingCurrency = "funding_currency"
        case isVoided = "voided"
        case charge
        case transaction
        case metadata
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        object = try container.decode(String.self, forKey: .object)
        location = try container.decode(String.self, forKey: .location)
        id = try container.decode(DataID<Refund>.self, forKey: .id)
        isLiveMode = try container.decode(Bool.self, forKey: .isLiveMode)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        status = try container.decode(Status.self, forKey: .status)
        amount = try container.decode(Int64.self, forKey: .amount)
        currency = try container.decode(Currency.self, forKey: .currency)
        fundingAmount = try container.decode(Int64.self, forKey: .fundingAmount)
        fundingCurrency = try container.decode(Currency.self, forKey: .fundingCurrency)
        isVoided = try container.decode(Bool.self, forKey: .isVoided)
        charge = try container.decode(DetailProperty<Charge>.self, forKey: .charge)
        transaction = try container.decode(DetailProperty<Transaction>.self, forKey: .transaction)
        metadata = try container.decode(JSONDictionary.self, forKey: .metadata)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(object, forKey: .object)
        try container.encode(location, forKey: .location)
        try container.encode(id, forKey: .id)
        try container.encode(isLiveMode, forKey: .isLiveMode)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(status, forKey: .status)
        try container.encode(amount, forKey: .amount)
        try container.encode(currency, forKey: .currency)
        try container.encode(fundingAmount, forKey: .fundingAmount)
        try container.encode(fundingCurrency, forKey: .fundingCurrency)
        try container.encode(isVoided, forKey: .isVoided)
        try container.encode(charge, forKey: .charge)
        try container.encode(transaction, forKey: .transaction)
        try container.encode(metadata, forKey: .metadata)
    }
}

public struct RefundParams: APIJSONQuery {
    public var amount: Int64
    public var isVoid: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case amount
        case isVoid = "void"
    }
    
    public init(amount: Int64, void: Bool? = nil) {
        self.amount = amount
        self.isVoid = void
    }
}


public struct RefundFilterParams: OmiseFilterParams {
    public var amount: Double?
    public var cardLastDigits: LastDigits?
    public var createdDate: DateComponents?
    public var isVoided: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case amount
        case cardLastDigits = "card_last_digits"
        case createdDate = "created_at"
        case isVoided = "voided"
    }
    
    public init(amount: Double? = nil, cardLastDigits: LastDigits? = nil,
        createdDate: DateComponents? = nil, isVoided: Bool? = nil) {
        self.amount = amount
        self.cardLastDigits = cardLastDigits
        self.createdDate = createdDate
        self.isVoided = isVoided
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        cardLastDigits = try container.decodeIfPresent(LastDigits.self, forKey: .cardLastDigits)
        createdDate = try container.decode(DateComponents.self, forKey: .createdDate)
        isVoided = try container.decodeIfPresent(Bool.self, forKey: .isVoided)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(cardLastDigits, forKey: .cardLastDigits)
        try container.encodeIfPresent(createdDate, forKey: .createdDate)
        try container.encodeIfPresent(isVoided, forKey: .isVoided)
    }
}


extension Refund: Creatable {
    public typealias CreateParams = RefundParams
}

extension Refund: Listable {}
extension Refund: Retrievable {}
extension Refund: Searchable {
    public typealias FilterParams = RefundFilterParams
}

extension Refund: OmiseAPIChildObject {
    public typealias Parent = Charge
}


extension Charge {
    public func retrieveRefund(using client: APIClient, id: DataID<Refund>, callback: @escaping Refund.RetrieveRequest.Callback) -> Refund.RetrieveRequest? {
        return Refund.retrieve(using: client, parent: self, id: id, callback: callback)
    }
    
    public func createRefund(using client: APIClient, params: RefundParams, callback: @escaping Refund.CreateRequest.Callback) -> Refund.CreateRequest? {
        return Refund.create(using: client, parent: self, params: params, callback: callback)
    }
}


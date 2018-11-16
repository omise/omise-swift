import Foundation


public struct Refund: OmiseLocatableObject, OmiseIdentifiableObject, OmiseCreatableObject, Equatable {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/refunds")
    
    public let object: String
    public let location: String
    
    public let id: String
    public var createdDate: Date
    
    public var value: Value {
        return Value(amount: amount, currency: currency)
    }
    
    public let amount: Int64
    public let currency: Currency
    
    public let isVoided: Bool
    
    public let charge: DetailProperty<Charge>
    public let transaction: DetailProperty<Transaction>
    
    public let metadata: JSONDictionary
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        object = try container.decode(String.self, forKey: .object)
        location = try container.decode(String.self, forKey: .location)
        id = try container.decode(String.self, forKey: .id)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        amount = try container.decode(Int64.self, forKey: .amount)
        currency = try container.decode(Currency.self, forKey: .currency)
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
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(amount, forKey: .amount)
        try container.encode(currency, forKey: .currency)
        try container.encode(isVoided, forKey: .isVoided)
        try container.encode(charge, forKey: .charge)
        try container.encode(transaction, forKey: .transaction)
        try container.encode(metadata, forKey: .metadata)
    }
    
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case createdDate = "created"
        case amount
        case currency
        case isVoided = "voided"
        case charge
        case transaction
        case metadata
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

extension Refund: Creatable {
    public typealias CreateParams = RefundParams
}

extension Refund: Listable {}
extension Refund: Retrievable {}


extension Charge {
    public func listRefunds(using client: APIClient, params: ListParams? = nil, callback: @escaping Refund.ListRequest.Callback) -> Refund.ListRequest? {
        return Refund.list(using: client, parent: self, params: params, callback: callback)
    }
    
    public func retrieveRefund(using client: APIClient, id: String, callback: @escaping Refund.RetrieveRequest.Callback) -> Refund.RetrieveRequest? {
        return Refund.retrieve(using: client, parent: self, id: id, callback: callback)
    }
    
    public func createRefund(using client: APIClient, params: RefundParams, callback: @escaping Refund.CreateRequest.Callback) -> Refund.CreateRequest? {
        return Refund.create(using: client, parent: self, params: params, callback: callback)
    }
}


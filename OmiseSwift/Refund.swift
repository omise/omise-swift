import Foundation


public struct Refund: OmiseLocatableObject, OmiseIdentifiableObject, OmiseCreatableObject {
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
    
    public let charge: DetailProperty<Charge>
    public let transaction: DetailProperty<Transaction>
    
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case createdDate = "created"
        case amount
        case currency
        case charge
        case transaction
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


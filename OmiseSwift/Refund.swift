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
}

extension Refund {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Refund.parseOmiseProperties(JSON: json) else {
                return nil
        }
        
        guard let amount = json["amount"] as? Int64, let currency = (json["currency"] as? String).flatMap(Currency.init(code:)),
            let charge = json["charge"].flatMap(DetailProperty<Charge>.init(JSON:)),
            let transaction = json["transaction"].flatMap(DetailProperty<Transaction>.init(JSON:)) else {
                return nil
        }
        (self.object, self.location, self.id, self.createdDate) = omiseObjectProperties
        
        self.amount = amount
        self.currency = currency
        self.charge = charge
        self.transaction = transaction
    }
}


public struct RefundParams: APIJSONQuery {
    public var amount: Int64
    public var isVoid: Bool?
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "amount": amount,
            "void": isVoid,
            ])
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


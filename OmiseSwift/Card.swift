import Foundation

open class Card: ResourceObject {
    open override class var info: ResourceInfo {
        return ResourceInfo(parentType: Customer.self, path: "/cards")
    }
    
    public var country: String? {
        get { return get("country", StringConverter.self) }
        set { set("country", StringConverter.self, toValue: newValue) }
    }
    
    public var city: String? {
        get { return get("city", StringConverter.self) }
        set { set("city", StringConverter.self, toValue: newValue) }
    }
    
    public var bank: String? {
        get { return get("bank", StringConverter.self) }
        set { set("bank", StringConverter.self, toValue: newValue) }
    }
    
    public var postalCode: String? {
        get { return get("postal_code", StringConverter.self) }
        set { set("postal_code", StringConverter.self, toValue: newValue) }
    }
    
    public var financing: String? {
        get { return get("financing", StringConverter.self) }
        set { set("financing", StringConverter.self, toValue: newValue) }
    }
    
    public var lastDigits: LastDigits? {
        get { return get("last_digits", LastDigitsConverter.self) }
        set { set("last_digits", LastDigitsConverter.self, toValue: newValue) }
    }
    
    public var brand: CardBrand? {
        get { return get("brand", EnumConverter.self) }
        set { set("brand", EnumConverter.self, toValue: newValue) }
    }
    
    public var expirationMonth: Int? {
        get { return get("expiration_month", IntConverter.self) }
        set { set("expiration_month", IntConverter.self, toValue: newValue) }
    }
    
    public var expirationYear: Int? {
        get { return get("expiration_year", IntConverter.self) }
        set { set("expiration_year", IntConverter.self, toValue: newValue) }
    }
    
    public var fingerprint: String? {
        get { return get("fingerprint", StringConverter.self) }
        set { set("fingerprint", StringConverter.self, toValue: newValue) }
    }
    
    public var name: String? {
        get { return get("name", StringConverter.self) }
        set { set("name", StringConverter.self, toValue: newValue) }
    }
    
    public var securityCodeCheck: Bool? {
        get { return get("security_code_check", BoolConverter.self) }
        set { set("security_code_check", BoolConverter.self, toValue: newValue) }
    }
}

public class CardParams: Params {
    public var name: String? {
        get { return get("name", StringConverter.self) }
        set { set("name", StringConverter.self, toValue: newValue) }
    }
    
    public var expirationMonth: Int? {
        get { return get("expiration_month", IntConverter.self) }
        set { set("expiration_month", IntConverter.self, toValue: newValue) }
    }
    
    public var expirationYear: Int? {
        get { return get("expiration_year", IntConverter.self) }
        set { set("expiration_year", IntConverter.self, toValue: newValue) }
    }
    
    public var postalCode: String? {
        get { return get("postal_code", StringConverter.self) }
        set { set("postal_code", StringConverter.self, toValue: newValue) }
    }
    
    public var city: String? {
        get { return get("city", StringConverter.self) }
        set { set("city", StringConverter.self, toValue: newValue) }
    }
}

extension Card: Listable { }
extension Card: Retrievable { }
extension Card: Destroyable { }

extension Card: Updatable {
    public typealias UpdateParams = CardParams
}

extension Customer {
    public func listCards(using given: Client? = nil, params: ListParams? = nil, callback: @escaping Card.ListOperation.Callback) -> Request<Card.ListOperation.Result>? {
        return Card.list(using: given ?? attachedClient, parent: self, params: params, callback: callback)
    }
    
    public func retrieveCard(using given: Client? = nil, id: String, callback: @escaping Card.RetrieveOperation.Callback) -> Request<Card.RetrieveOperation.Result>? {
        return Card.retrieve(using: given ?? attachedClient, parent: self, id: id, callback: callback)
    }
    
    public func updateCard(using given: Client? = nil, id: String, params: CardParams, callback: @escaping Card.UpdateOperation.Callback) -> Request<Card.UpdateOperation.Result>? {
        return Card.update(using: given ?? attachedClient, parent: self, id: id, params: params, callback: callback)
    }
    
    public func destroyCard(using given: Client? = nil, id: String, callback: @escaping Card.DestroyOperation.Callback) -> Request<Card.DestroyOperation.Result>? {
        return Card.destroy(using: given ?? attachedClient, parent: self, id: id, callback: callback)
    }
}

func exampleCard() {
    let customer = Customer()
    customer.id = "cust_test_123"
    
    _ = Card.list(parent: customer) { (result) in
        switch result {
        case let .success(cards):
            print("cards: \(cards)")
        case let .fail(err):
            print("error: \(err)")
        }
    }
}

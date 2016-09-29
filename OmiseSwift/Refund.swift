import Foundation

open class Refund: ResourceObject {
    open override class var info: ResourceInfo {
        return ResourceInfo(parentType: Charge.self, path: "/refunds")
    }
    
    public var amount: Int64? {
        get { return get("amount", Int64Converter.self) }
        set { set("amount", Int64Converter.self, toValue: newValue) }
    }
    
    public var currency: Currency? {
        get { return get("currency", StringConverter.self).flatMap(Currency.init(code:)) }
        set { set("currency", StringConverter.self, toValue: newValue?.code) }
    }
    
    public var charge: String? {
        get { return get("charge", StringConverter.self) }
        set { set("charge", StringConverter.self, toValue: newValue) }
    }
    
    public var transaction: String? {
        get { return get("transaction", StringConverter.self) }
        set { set("transaction", StringConverter.self, toValue: newValue) }
    }
}

public class RefundParams: Params {
    public var amount: Int64? {
        get { return get("amount", Int64Converter.self) }
        set { set("amount", Int64Converter.self, toValue: newValue) }
    }
    
    public var void: Bool? {
        get { return get("void", BoolConverter.self) }
        set { set("void", BoolConverter.self, toValue: newValue) }
    }
}

extension Refund: Creatable {
    public typealias CreateParams = RefundParams
}

extension Refund: Listable { }
extension Refund: Retrievable { }

extension Charge {
    public func listRefunds(using given: Client? = nil, params: ListParams? = nil, callback: @escaping Refund.ListOperation.Callback) -> Request<Refund.ListOperation.Result>? {
        return Refund.list(using: given ?? attachedClient, parent: self, params: params, callback: callback)
    }
    
    public func retrieveRefund(using given: Client? = nil, id: String, callback: @escaping Refund.RetrieveOperation.Callback) -> Request<Refund.RetrieveOperation.Result>? {
        return Refund.retrieve(using: given ?? attachedClient, parent: self, id: id, callback: callback)
    }
    
    public func createRefund(using given: Client? = nil, params: RefundParams, callback: @escaping Refund.CreateOperation.Callback) -> Request<Refund.RetrieveOperation.Result>? {
        return Refund.create(using: given ?? attachedClient, parent: self, params: params, callback: callback)
    }
}

func exampleRefund() {
    let charge = Charge()
    charge.id = "chrg_test_123"
    
    let params = RefundParams()
    params.amount = 1_000_00 // 1,000.00 THB
    params.void = true
    
    _ = Refund.create(parent: charge, params: params) { (result) in
        switch result {
        case let .success(refund):
            print("created refund: \(refund.id)")
        case let .fail(err):
            print("error: \(err)")
        }
    }
}

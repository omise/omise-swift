import Foundation

public class Charge: ResourceObject {
    public override class var info: ResourceInfo { return ResourceInfo(path: "/charges") }
    
    public var status: ChargeStatus? {
        get { return get("status", EnumConverter.self) }
        set { set("status", EnumConverter.self, toValue: newValue) }
    }
    
    public var amount: Int64? {
        get { return get("amount", Int64Converter.self) }
        set { set("amount", Int64Converter.self, toValue: newValue) }
    }
    
    public var currency: Currency? {
        get { return get("currency", StringConverter.self).flatMap(Currency.init(code:)) }
        set { set("currency", StringConverter.self, toValue: newValue?.code) }
    }
    
    public var chargeDescription: String? {
        get { return get("description", StringConverter.self) }
        set { set("description", StringConverter.self, toValue: newValue) }
    }
    
    public var capture: Bool? {
        get { return get("capture", BoolConverter.self) }
        set { set("capture", BoolConverter.self, toValue: newValue) }
    }
    
    public var authorized: Bool? {
        get { return get("authorized", BoolConverter.self) }
        set { set("authorized", BoolConverter.self, toValue: newValue) }
    }
    
    public var paid: Bool? {
        get { return get("paid", BoolConverter.self) }
        set { set("paid", BoolConverter.self, toValue: newValue) }
    }
    
    public var transaction: String? {
        get { return get("transaction", StringConverter.self) }
        set { set("transaction", StringConverter.self, toValue: newValue) }
    }
    
    public var card: Card? {
        get { return getChild("card", Card.self) }
        set { setChild("card", Card.self, toValue: newValue) }
    }
    
    public var refunded: Int64? {
        get { return get("refunded", Int64Converter.self) }
        set { set("refunded", Int64Converter.self, toValue: newValue) }
    }
    
    public var refunds: OmiseList<Refund>? {
        get { return getChild("refunds", OmiseList<Refund>.self) }
        set { setChild("refunds", OmiseList<Refund>.self, toValue: newValue) }
    }
    
    public var failureCode: String? {
        get { return get("failure_code", StringConverter.self) }
        set { set("failure_code", StringConverter.self, toValue: newValue) }
    }
    
    public var failureMessage: String? {
        get { return get("failure_message", StringConverter.self) }
        set { set("failure_message", StringConverter.self, toValue: newValue) }
    }
    
    public var customer: String? {
        get { return get("customer", StringConverter.self) }
        set { set("customer", StringConverter.self, toValue: newValue) }
    }
    
    public var ip: String? {
        get { return get("ip", StringConverter.self) }
        set { set("ip", StringConverter.self, toValue: newValue) }
    }
    
    public var dispute: Dispute? {
        get { return getChild("dispute", Dispute.self) }
        set { setChild("dispute", Dispute.self, toValue: newValue) }
    }
    
    public var returnUri: String? {
        get { return get("return_uri", StringConverter.self) }
        set { set("return_uri", StringConverter.self, toValue: newValue) }
    }
    
    public var authorizeUri: String? {
        get { return get("authorize_uri", StringConverter.self) }
        set { set("authorize_uri", StringConverter.self, toValue: newValue) }
    }
}

public class ChargeParams: Params {
    public var customer: String? {
        get { return get("customer", StringConverter.self) }
        set { set("customer", StringConverter.self, toValue: newValue) }
    }
    
    public var card: String? {
        get { return get("card", StringConverter.self) }
        set { set("card", StringConverter.self, toValue: newValue) }
    }
    
    public var amount: Int64? {
        get { return get("amount", Int64Converter.self) }
        set { set("amount", Int64Converter.self, toValue: newValue) }
    }
    
    public var currency: Currency? {
        get { return get("currency", StringConverter.self).flatMap(Currency.init(code:)) }
        set { set("currency", StringConverter.self, toValue: newValue?.code) }
    }
    
    public var description: String? {
        get { return get("description", StringConverter.self) }
        set { set("description", StringConverter.self, toValue: newValue) }
    }
    
    public var capture: Bool? {
        get { return get("capture", BoolConverter.self) }
        set { set("capture", BoolConverter.self, toValue: newValue) }
    }
    
    public var returnUri: String? {
        get { return get("return_uri", StringConverter.self) }
        set { set("return_uri", StringConverter.self, toValue: newValue) }
    }
}

public class ChargeFilterParams: OmiseFilterParams {
    public var created: NSDateComponents? {
        get { return get("created", DateComponentsConverter.self) }
        set { set("created", DateComponentsConverter.self, toValue: newValue) }
    }
    public var amount: Int64? {
        get { return get("amount", Int64Converter.self) }
        set { set("amount", Int64Converter.self, toValue: newValue) }
    }
    
    public var authorized: Bool? {
        get { return get("authorized", BoolConverter.self) }
        set { set("authorized", BoolConverter.self, toValue: newValue) }
    }
    
    public var capture: Bool? {
        get { return get("captured", BoolConverter.self) }
        set { set("captured", BoolConverter.self, toValue: newValue) }
    }
    
    public var cardLastDigits: String? {
        get { return get("card_last_digits", StringConverter.self) }
        set { set("card_last_digits", StringConverter.self, toValue: newValue) }
    }
    
    public var customerPresent: Bool? {
        get { return get("customer_present", BoolConverter.self) }
        set { set("customer_present", BoolConverter.self, toValue: newValue) }
    }
    
    public var failureCode: String? {
        get { return get("failure_code", StringConverter.self) }
        set { set("failure_code", StringConverter.self, toValue: newValue) }
    }
    
}

extension Charge: Listable { }
extension Charge: Retrievable { }

extension Charge: Creatable {
    public typealias CreateParams = ChargeParams
}

extension Charge: Updatable {
    public typealias UpdateParams = ChargeParams
}

extension Charge: Searchable {
    public typealias FilterParams = ChargeFilterParams
}

extension Charge {
    public typealias CaptureOperation = Operation<Charge>
    public typealias ReverseOperation = Operation<Charge>
    
    public static func capture(using given: Client? = nil, id: String, callback: CaptureOperation.Callback) -> Request<CaptureOperation.Result>? {
        let operation = CaptureOperation(
            endpoint: info.endpoint,
            method: "POST",
            paths: [info.path, id, "capture"]
        )
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
    
    public static func reverse(using given: Client? = nil, id: String, callback: ReverseOperation.Callback) -> Request<ReverseOperation.Result>? {
        let operation = ReverseOperation(
            endpoint: info.endpoint,
            method: "POST",
            paths: [info.path, id, "reverse"]
        )
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}

func exampleCharge() {
    Charge.list { (result) in
        switch result {
        case let .Success(charges):
            print("charges: \(charges.data[0].id)")
        case let .Fail(err):
            print("error: \(err)")
        }
    }
    
    Charge.retrieve(id: "chrg_test_123") { (result) in
        switch result {
        case let .Success(charge):
            print("charge: \(charge.id) \(charge.amount)")
        case let .Fail(err):
            print("error: \(err)")
        }
    }
    
    Charge.reverse(id: "chrg_test_123") { (result) in
        switch result {
        case let .Success(charge):
            print("reversed charge: \(charge.id)")
        case let .Fail(err):
            print("error: \(err)")
        }
    }
}

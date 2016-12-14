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
    
    public var offsite: OffsitePayment? {
        get { return get("offsite", OffsitePaymentConverter.self) }
        set { set("offsite", OffsitePaymentConverter.self, toValue: newValue) }
    }
    
    public var payment: Payment? {
        switch get("source_of_fund", StringConverter.self) {
        case "offsite"?:
            return offsite.map(Payment.offsite)
        case "card"?, nil /* nil for backward compatability */ :
            return card.map(Payment.card)
        default: return nil
        }
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
    public var created: DateComponents? {
        get { return get("created", DateComponentsConverter.self) }
        set { set("created", DateComponentsConverter.self, toValue: newValue) }
    }
    public var amount: Double? {
        get { return get("amount", DoubleConverter.self) }
        set { set("amount", DoubleConverter.self, toValue: newValue) }
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
    
    public static func captureOperation(id: String) -> CaptureOperation {
        return CaptureOperation(
            endpoint: info.endpoint,
            method: "POST",
            paths: [info.path, id, "capture"]
        )
    }
    
    public static func capture(using given: Client? = nil, id: String, callback: @escaping CaptureOperation.Callback) -> Request<CaptureOperation.Result>? {
        let operation = captureOperation(id: id)
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
    
    public static func reverse(id: String) -> CaptureOperation {
        return ReverseOperation(
            endpoint: info.endpoint,
            method: "POST",
            paths: [info.path, id, "reverse"]
        )
    }
    
    public static func reverse(using given: Client? = nil, id: String, callback: @escaping ReverseOperation.Callback) -> Request<ReverseOperation.Result>? {
        let operation = reverse(id: id)
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}

func exampleCharge() {
    _ = Charge.list { (result) in
        switch result {
        case let .success(charges):
            print("charges: \(charges.data[0].id)")
        case let .fail(err):
            print("error: \(err)")
        }
    }
    
    _ = Charge.retrieve(id: "chrg_test_123") { (result) in
        switch result {
        case let .success(charge):
            print("charge: \(charge.id) \(charge.amount)")
        case let .fail(err):
            print("error: \(err)")
        }
    }
    
    _ = Charge.reverse(id: "chrg_test_123") { (result) in
        switch result {
        case let .success(charge):
            print("reversed charge: \(charge.id)")
        case let .fail(err):
            print("error: \(err)")
        }
    }
}

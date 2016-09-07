import Foundation

public class Dispute: ResourceObject {
    public override class var info: ResourceInfo { return ResourceInfo(path: "/disputes") }
    
    public var amount: Int64? {
        get { return get("amount", Int64Converter.self) }
        set { set("amount", Int64Converter.self, toValue: newValue) }
    }
    
    public var currency: Currency? {
        get { return get("currency", StringConverter.self).flatMap(Currency.init(code:)) }
        set { set("currency", StringConverter.self, toValue: newValue?.code) }
    }
    
    public var status: DisputeStatus? {
        get { return get("status", EnumConverter.self) }
        set { set("status", EnumConverter.self, toValue: newValue) }
    }
    
    public var message: String? {
        get { return get("message", StringConverter.self) }
        set { set("message", StringConverter.self, toValue: newValue) }
    }
    
    public var charge: String? {
        get { return get("charge", StringConverter.self) }
        set { set("charge", StringConverter.self, toValue: newValue) }
    }
}

public class DisputeParams: Params {
    public var message: String? {
        get { return get("message", StringConverter.self) }
        set { set("message", StringConverter.self, toValue: newValue) }
    }
}

public class DisputeFilterParams: OmiseFilterParams {
    public var created: NSDateComponents? {
        get { return get("created", DateComponentsConverter.self) }
        set { set("created", DateComponentsConverter.self, toValue: newValue) }
    }
    
    public var cardLastDigits: String? {
        get { return get("card_last_digits", StringConverter.self) }
        set { set("card_last_digits", StringConverter.self, toValue: newValue) }
    }
    
    public var reasonCode: String? {
        get { return get("reason_code", StringConverter.self) }
        set { set("reason_code", StringConverter.self, toValue: newValue) }
    }
    
    public var status: DisputeStatus? {
        get { return get("status", EnumConverter.self) }
        set { set("status", EnumConverter.self, toValue: newValue) }
    }
}

extension Dispute: Listable { }
extension Dispute: Retrievable { }

extension Dispute: Updatable {
    public typealias UpdateParams = DisputeParams
}

extension Dispute: Searchable {
    public typealias FilterParams = DisputeFilterParams
}

extension Dispute {
    public static func list(using given: Client? = nil, state: DisputeStatus, params: ListParams? = nil, callback: Dispute.ListOperation.Callback) -> Request<Dispute.ListOperation.Result>? {
        let operation = ListOperation(
            endpoint: info.endpoint,
            method: "GET",
            paths: [info.path, state.rawValue]
        )
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}

func exampleDispute() {
    let _: [DisputeStatus] = [.Open, .Pending, .Closed] // valid statuses
    
    Dispute.list(state: .Open) { (result) in
        switch result {
        case let .Success(list):
            print("open disputes: \(list.data.count)")
        case let .Fail(err):
            print("error: \(err)")
        }
    }
}
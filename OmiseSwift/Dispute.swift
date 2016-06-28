import Foundation

public class Dispute: ResourceObject {
    public override class var resourcePath: String { return "/disputes" }
    
    public var amount: Int64? {
        get { return get("amount", Int64Converter.self) }
        set { set("amount", Int64Converter.self, toValue: newValue) }
    }
    
    public var currency: String? {
        get { return get("currency", StringConverter.self) }
        set { set("currency", StringConverter.self, toValue: newValue) }
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

extension Dispute: Listable { }
extension Dispute: InstanceRetrievable { }

extension Dispute: Updatable {
    public typealias UpdateParams = DisputeParams
}

extension Dispute {
    public static func list(using given: Client? = nil, state: DisputeStatus, params: ListParams? = nil, callback: Request<Dispute.ListOperation>.Callback) -> Request<Dispute.ListOperation>? {
        let attributes = params?.normalizedAttributes ?? [:]
        let operation = ListOperation(klass: self, attributes: attributes)
        operation.path += state.rawValue
        
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
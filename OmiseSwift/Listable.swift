import Foundation

public protocol Listable { }

public class ListParams: Params {
    public var from: Date? {
        get { return get("from", DateConverter.self) }
        set { set("from", DateConverter.self, toValue: newValue) }
    }
    
    public var to: Date? {
        get { return get("to", DateConverter.self) }
        set { set("to", DateConverter.self, toValue: newValue) }
    }
    
    public var offset: Int? {
        get { return get("offset", IntConverter.self) }
        set { set("offset", IntConverter.self, toValue: newValue) }
    }
    
    public var limit: Int? {
        get { return get("limit", IntConverter.self) }
        set { set("limit", IntConverter.self, toValue: newValue) }
    }
    
    public var order: Ordering? {
        get { return get("order", EnumConverter.self) }
        set { set("order", EnumConverter.self, toValue: newValue) }
    }
}

public extension Listable where Self: ResourceObject {
    public typealias ListOperation = Operation<OmiseList<Self>>
    
    public static func listOperation(_ parent: ResourceObject?, params: ListParams?) -> ListOperation {
        return ListOperation(
            endpoint: info.endpoint,
            method: "GET",
            paths: makeResourcePathsWith(context: self, parent: parent),
            params: params
        )
    }
    
    public static func list(using given: Client? = nil, parent: ResourceObject? = nil, params: ListParams? = nil, callback: ListOperation.Callback?) -> Request<ListOperation.Result>? {
        guard checkParent(withContext: self, parent: parent) else {
            return nil
        }
        
        let operation = self.listOperation(parent, params: params)
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}

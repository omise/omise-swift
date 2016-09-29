import Foundation

public protocol Searchable {
    static var scopeName: String { get }
    associatedtype FilterParams: OmiseFilterParams
}

extension Searchable {
    public static var scopeName: String {
        return String(describing: self).lowercased()
    }
}

public class SearchParams<FilterParams: OmiseFilterParams>: Params {
    public var scope: String? {
        get { return get("scope", StringConverter.self) }
        set { set("scope", StringConverter.self, toValue: newValue) }
    }
    
    public var page: Int? {
        get { return get("page", IntConverter.self) }
        set { set("page", IntConverter.self, toValue: newValue) }
    }
    
    public var query: String? {
        get { return get("query", StringConverter.self) }
        set { set("query", StringConverter.self, toValue: newValue) }
    }
    
    public var order: Ordering? {
        get { return get("order", EnumConverter.self) }
        set { set("order", EnumConverter.self, toValue: newValue) }
    }
    
    public var filter: FilterParams? {
        get { return getChild("filters", FilterParams.self) }
        set { setChild("filters", FilterParams.self, toValue: newValue) }
    }
    
    public required init(attributes: JSONAttributes = [:]) {
        super.init(attributes: attributes)
    }
}

public class OmiseFilterParams: Params {
    
}


public extension Searchable where Self: ResourceObject {
    public typealias SearchOperation = Operation<OmiseList<Self>>
    
    public static func searchOperation(parent: ResourceObject?, params: SearchParams<FilterParams>?) -> SearchOperation {
        return SearchOperation(
            endpoint: .api,
            method: "GET",
            paths: ["search"],
            params: params
        )
    }
    
    public static func search(using given: Client? = nil, parent: ResourceObject? = nil, params: SearchParams<FilterParams>? = nil, callback: SearchOperation.Callback?) -> Request<SearchOperation.Result>? {
        guard checkParent(withContext: self, parent: parent) else {
            return nil
        }
        
        let operation = self.searchOperation(parent: parent, params: params)
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}

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

public struct SearchParams<FilterParams: OmiseFilterParams>: APIParams {
    public var scope: String
    public var page: Int?
    public var query: String?
    public var order: Ordering?
    public var filter: FilterParams?
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "scope": scope,
            "page": page,
            "query": query,
            "order": order?.rawValue,
            "filters": filter?.json,
        ])
    }
    
    public init(scope: String, page: Int? = nil, query: String? = nil, order: Ordering? = nil, filter: FilterParams? = nil) {
        self.scope = scope
        self.page = page
        self.query = query
        self.order = order
        self.filter = filter
    }
    
    public init<T: Searchable>(searhScopeType: T.Type,
                page: Int? = nil, query: String? = nil, order: Ordering? = nil, filter: FilterParams? = nil)
        where T.FilterParams == FilterParams {
            self.init(scope: T.scopeName, page: page, query: query, order: order, filter: filter)
    }
}

public protocol OmiseFilterParams: APIParams {
    init(JSON: [String: Any])
}


public extension Searchable where Self: OmiseResourceObject {
    public typealias SearchEndpoint = APIEndpoint<SearchResult<Self>>
    public typealias SearchRequest = APIRequest<SearchResult<Self>>

    public static func searchEndpoint(parent: OmiseResourceObject?, params: SearchParams<FilterParams>?) -> SearchEndpoint {
        return SearchEndpoint(
            endpoint: .api,
            method: "GET",
            pathComponents: ["search"],
            params: params
        )
    }
    
    public static func search(using client: APIClient, parent: OmiseResourceObject? = nil, params: SearchParams<FilterParams>? = nil, callback: SearchRequest.Callback?) -> SearchRequest? {
        guard verifyParent(parent) else {
            return nil
        }
        
        let endpoint = self.searchEndpoint(parent: parent, params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

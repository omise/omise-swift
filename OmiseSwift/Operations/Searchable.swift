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

public struct SearchParams<FilterParams: OmiseFilterParams>: APIJSONQuery {
    public var scope: String
    public var query: String?
    public var order: Ordering?
    public var filter: FilterParams?
    
    public var page: Int?
    public var numberOfItemsPerPage: Int?
    
    private enum CodingKeys: String, CodingKey {
        case scope
        case query
        case order
        case filter = "filters"
        
        case page
        case numberOfItemsPerPage = "per_page"
    }
    
    public init(
        scope: String, query: String? = nil, order: Ordering? = nil, filter: FilterParams? = nil,
        page: Int? = nil, numberOfItemsPerPage: Int? = nil
        ) {
        self.scope = scope
        self.query = query
        self.order = order
        self.filter = filter
        self.page = page
        self.numberOfItemsPerPage = numberOfItemsPerPage
    }
    
    public init<T: Searchable>(searhScopeType: T.Type,
                               query: String? = nil, order: Ordering? = nil, filter: FilterParams? = nil,
                               page: Int? = nil,  numberOfItemsPerPage: Int? = nil)
        where T.FilterParams == FilterParams {
            self.init(
                scope: T.scopeName, query: query, order: order, filter: filter,
                page: page, numberOfItemsPerPage: numberOfItemsPerPage)
    }
}


public protocol OmiseFilterParams: APIJSONQuery , Decodable {}


public extension OmiseAPIPrimaryObject where Self: Searchable {
    typealias SearchEndpoint = APIEndpoint<SearchParams<FilterParams>, SearchResult<Self>>
    typealias SearchRequest = APIRequest<SearchParams<FilterParams>, SearchResult<Self>>
    
    static func searchEndpoint(with params: SearchParams<FilterParams>?) -> SearchEndpoint {
        return SearchEndpoint(
            endpoint: .api,
            pathComponents: ["search"],
            method: .get, query: params)
    }
    
    static func search(
        using client: APIClient, params: SearchParams<FilterParams>? = nil,
        callback: SearchRequest.Callback?
        ) -> SearchRequest? {
        let endpoint = self.searchEndpoint(with: params)
        return client.request(to: endpoint, callback: callback)
    }
    
    @discardableResult
    static func search(
        using client: APIClient, searchParams: SearchParams<FilterParams>? = nil,
        callback: @escaping (APIResult<Search<Self>>) -> Void
        ) -> SearchRequest? {
        let endpoint = self.searchEndpoint(with: searchParams)
        
        let requestCallback: SearchRequest.Callback = { result in
            let callbackResult = result.map({
                Search(result: $0, order: searchParams?.order ?? .chronological)
            })
            callback(callbackResult)
        }
        
        return client.request(to: endpoint, callback: requestCallback)
    }
    
    static func makeLoadNextPageOperation(list: Search<Self>) -> SearchEndpoint {
        let listParams = SearchParams(
            scope: list.scope, query: list.query, order: list.order, filter: list.filters,
            page: list.loadedPages.last?.advanced(by: 1) ?? 1)
        
        return SearchEndpoint(endpoint: .api, pathComponents: ["search"], method: .get, query: listParams)
    }
    
    @discardableResult
    static func loadNextPage(
        list: Search<Self>, using client: APIClient,
        callback: @escaping (APIResult<[Self]>) -> Void
        ) -> APIRequest<SearchParams<FilterParams>, SearchEndpoint.Result>? {
        let operation = makeLoadNextPageOperation(list: list)
        
        let requestCallback: SearchRequest.Callback = { result in
            let callbackResult = result.map({ list.insert(from: $0) })
            callback(callbackResult)
        }
        
        return client.request(to: operation, callback: requestCallback)
    }
    
    static func makeLoadPreviousPageOperation(list: Search<Self>) -> SearchEndpoint {
        let listParams = SearchParams(
            scope: list.scope, query: list.query, order: list.order, filter: list.filters,
            page: list.loadedPages.last?.advanced(by: -1) ?? 1)
        
        return SearchEndpoint(endpoint: .api, pathComponents: ["search"], method: .get, query: listParams)
    }
    
    @discardableResult
    static func loadPreviousPage(
        list: Search<Self>, using client: APIClient,
        callback: @escaping (APIResult<[Self]>) -> Void
        ) -> APIRequest<SearchParams<FilterParams>, SearchEndpoint.Result>? {
        let operation = makeLoadNextPageOperation(list: list)
        
        let requestCallback: SearchRequest.Callback = { result in
            let callbackResult = result.map({ list.insert(from: $0) })
            callback(callbackResult)
        }
        
        return client.request(to: operation, callback: requestCallback)
    }
}


public extension APIClient {
    func create<T: OmiseAPIPrimaryObject & Searchable>(
        params: SearchParams<T.FilterParams>, callback: @escaping T.SearchRequest.Callback
        ) -> T.SearchRequest? {
        return T.search(using: self, params: params, callback: callback)
    }
}


import Foundation

public protocol Listable {}

public struct ListParams: APIParams {
    public var from: Date?
    public var to: Date?
    public var offset: Int?
    public var limit: Int?
    public var order: Ordering?
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "from": DateConverter.convert(fromValue: from),
            "to": DateConverter.convert(fromValue: to),
            "offset": offset,
            "limit": limit,
            "order": order?.rawValue
        ])
    }
    
    
    public init(from: Date? = nil, to: Date? = nil, offset: Int? = nil, limit: Int? = nil, order: Ordering? = nil) {
        self.from = from
        self.to = to
        self.offset = offset
        self.limit = limit
        self.order = order
    }
}

public extension Listable where Self: OmiseLocatableObject {
    public typealias ListEndpoint = APIEndpoint<ListProperty<Self>>
    public typealias ListRequest = APIRequest<ListProperty<Self>>
    
    @discardableResult
    public static func listEndpointWith(parent: OmiseResourceObject?, params: ListParams?) -> ListEndpoint {
        return ListEndpoint(
            method: "GET",
            pathComponents: makeResourcePathsWithParent(parent),
            params: params
        )
    }
    
    @discardableResult
    public static func list(using client: APIClient, parent: OmiseResourceObject? = nil, params: ListParams? = nil, callback: ListRequest.Callback?) -> ListRequest? {
        guard verifyParent(parent) else {
            return nil
        }
        
        let endpoint = self.listEndpointWith(parent: parent, params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    @discardableResult
    public static func list(using client: APIClient, parent: OmiseResourceObject? = nil, listParams: ListParams? = nil, callback: @escaping (Failable<List<Self>>) -> Void) -> ListRequest? {
        guard verifyParent(parent) else {
            return nil
        }
        
        let endpoint = self.listEndpointWith(parent: parent, params: listParams)
        
        let requestCallback: ListRequest.Callback = { result in
            let callbackResult = result.map({
                List(endpoint: endpoint.endpoint, paths: endpoint.pathComponents, order: listParams?.order, list: $0)
            })
            callback(callbackResult)
        }
        
        return client.requestToEndpoint(endpoint, callback: requestCallback)
    }
    
    public static func makeLoadNextPageOperation(list: List<Self>, count: Int?) -> ListEndpoint {
        let listParams = ListParams(from: nil, to: nil, offset: list.loadedIndices.last?.advanced(by: 1) ?? 0, limit: count ?? list.limit, order: list.order)
        
        return ListEndpoint(endpoint: list.endpoint, method: "GET", pathComponents: list.paths, params: listParams)
    }
    
    @discardableResult
    static func loadNextPage(list: List<Self>, using client: APIClient, count: Int? = nil, callback: @escaping (Failable<[Self]>) -> Void) -> APIRequest<ListEndpoint.Result>? {
        let operation = makeLoadNextPageOperation(list: list, count: count)
        
        let requestCallback: ListRequest.Callback = { result in
            let callbackResult = result.map({ list.insert(from: $0) })
            callback(callbackResult)
        }
        
        return client.requestToEndpoint(operation, callback: requestCallback)
    }
    
    public static func makeLoadPreviousPageOperation(list: List<Self>, count: Int?) -> ListEndpoint {
        let listParams = ListParams(from: nil, to: nil, offset: list.loadedFirstIndex.advanced(by: -list.limit), limit: count ?? list.limit, order: list.order)
        
        return ListEndpoint(endpoint: list.endpoint, method: "GET", pathComponents: list.paths, params: listParams)
    }
    
    @discardableResult
    static func loadPreviousPage(list: List<Self>, using client: APIClient, count: Int? = nil, callback: @escaping (Failable<[Self]>) -> Void) -> APIRequest<ListEndpoint.Result>? {
        let operation = makeLoadPreviousPageOperation(list: list, count: count)
        
        let requestCallback: ListRequest.Callback = { result in
            switch result {
            case .success(let result):
                let insertedData = list.insert(from: result)
                callback(.success(insertedData))
            case .fail(let error):
                callback(.fail(error))
            }
        }
        
        return client.requestToEndpoint(operation, callback: requestCallback)
    }
}

extension List where TItem: OmiseResourceObject, TItem: Listable {
    public func loadNextPage(using client: APIClient, count: Int? = nil, callback: @escaping (Failable<[TItem]>) -> Void) {
        TItem.loadNextPage(list: self, using: client, count: count) { (result) in
            switch result {
            case .success(let addedValues):
                callback(.success(addedValues))
            case .fail(let error):
                callback(.fail(error))
            }
        }
    }
    
    public func loadPreviousPage(using client: APIClient, count: Int? = nil, callback: @escaping (Failable<[TItem]>) -> Void) {
        TItem.loadPreviousPage(list: self, using: client, count: count) { (result) in
            switch result {
            case .success(let addedValues):
                callback(.success(addedValues))
            case .fail(let error):
                callback(.fail(error))
            }
        }
    }
}


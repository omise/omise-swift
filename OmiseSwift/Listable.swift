import Foundation

public protocol Listable {}

public struct ListParams: APIJSONQuery {
    public var from: Date?
    public var to: Date?
    public var offset: Int?
    public var limit: Int?
    public var order: Ordering?
    
    public init(from: Date? = nil, to: Date? = nil, offset: Int? = nil, limit: Int? = nil, order: Ordering? = nil) {
        self.from = from
        self.to = to
        self.offset = offset
        self.limit = limit
        self.order = order
    }
}

public extension OmiseAPIPrimaryObject where Self: Listable {
    typealias ListEndpoint = APIEndpoint<ListProperty<Self>>
    typealias ListRequest = APIRequest<ListProperty<Self>>
    

    @discardableResult
    static func listEndpointWith(params: ListParams?) -> ListEndpoint {
        return ListEndpoint(
            pathComponents: makeResourcePaths(),
            parameter: .get(params)
        )
    }
    
    @discardableResult
    static func list(using client: APIClient, params: ListParams? = nil, callback: ListRequest.Callback?) -> ListRequest? {
        let endpoint = self.listEndpointWith(params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    @discardableResult
    static func list(using client: APIClient, listParams: ListParams? = nil, callback: @escaping (Failable<List<Self>>) -> Void) -> ListRequest? {
        let endpoint = self.listEndpointWith(params: listParams)
        
        let requestCallback: ListRequest.Callback = { result in
            let callbackResult = result.map({
                List(endpoint: endpoint.endpoint, paths: endpoint.pathComponents, order: listParams?.order, list: $0)
            })
            callback(callbackResult)
        }
        
        return client.requestToEndpoint(endpoint, callback: requestCallback)
    }
}


public extension List where TItem: OmiseAPIPrimaryObject {
    func makeLoadNextPageOperation(count: Int?) -> TItem.ListEndpoint {
        let listParams = ListParams(from: nil, to: nil, offset: loadedIndices.last?.advanced(by: 1) ?? 0, limit: count ?? limit, order: order)
        
        return TItem.ListEndpoint(endpoint: endpoint, pathComponents: paths, parameter: .get(listParams))
    }
    
    @discardableResult
    func loadNextPage(using client: APIClient, count: Int? = nil, callback: @escaping (Failable<[TItem]>) -> Void) -> APIRequest<TItem.ListEndpoint.Result>? {
        let operation = makeLoadNextPageOperation(count: count)
        
        let requestCallback: TItem.ListRequest.Callback = { [weak self] result in
            guard let list = self else { return }
            let callbackResult = result.map({ list.insert(from: $0) })
            callback(callbackResult)
        }
        
        return client.requestToEndpoint(operation, callback: requestCallback)
    }
    
    func makeLoadPreviousPageOperation(count: Int?) -> TItem.ListEndpoint {
        let listParams = ListParams(from: nil, to: nil, offset: loadedFirstIndex.advanced(by: -limit), limit: count ?? limit, order: order)
        
        return TItem.ListEndpoint(endpoint: endpoint, pathComponents: paths, parameter: .get(listParams))
    }
    
    @discardableResult
    func loadPreviousPage(using client: APIClient, count: Int? = nil, callback: @escaping (Failable<[TItem]>) -> Void) -> TItem.ListRequest? {
        let operation = makeLoadPreviousPageOperation(count: count)
        
        let requestCallback: TItem.ListRequest.Callback = { [weak self] result in
            guard let list = self else { return }
            switch result {
            case .success(let result):
                let insertedData = list.insert(from: result)
                callback(.success(insertedData))
            case .failure(let error):
                callback(.failure(error))
            }
        }
        
        return client.requestToEndpoint(operation, callback: requestCallback)
    }
}

public extension List where TItem: OmiseAPIPrimaryObject & OmiseCreatedObject {
    func makeRefreshCurrentDataOperation() -> TItem.ListEndpoint {
        let listParams: ListParams
        
        if let from = data.last?.createdDate, total > 0, order == .reverseChronological {
            listParams = ListParams(from: from, to: nil, offset: nil, limit: 100, order: order)
        } else if let to = data.first?.createdDate, total > 0, order == .chronological {
            listParams = ListParams(from: nil, to: to, offset: nil, limit: 100, order: order)
        } else {
            listParams = ListParams(from: nil, to: nil, offset: nil, limit: nil, order: order)
        }
        
        return TItem.ListEndpoint(endpoint: endpoint, pathComponents: paths, parameter: .get(listParams))
    }
    
    @discardableResult
    func refreshData(using client: APIClient, callback: @escaping (Failable<[TItem]>) -> Void) -> TItem.ListRequest? {
        let operation = makeRefreshCurrentDataOperation()
        
        let requestCallback: TItem.ListRequest.Callback = { [weak self] result in
            guard let list = self else { return }
            switch result {
            case .success(let result):
                let refreshedData = list.setList(from: result)
                callback(.success(refreshedData))
            case .failure(let error):
                callback(.failure(error))
            }
        }
        
        return client.requestToEndpoint(operation, callback: requestCallback)
    }
}


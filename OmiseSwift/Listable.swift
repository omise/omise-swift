import Foundation

public protocol Listable {}

public struct ListParams: APIJSONQuery {
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
            pathComponents: makeResourcePathsWithParent(parent),
            parameter: .get(params)
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
}


public extension List where TItem: OmiseLocatableObject & Listable {
    public func makeLoadNextPageOperation(count: Int?) -> TItem.ListEndpoint {
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
    
    public func makeLoadPreviousPageOperation(count: Int?) -> TItem.ListEndpoint {
        let listParams = ListParams(from: nil, to: nil, offset: loadedFirstIndex.advanced(by: -limit), limit: count ?? limit, order: order)
        
        return TItem.ListEndpoint(endpoint: endpoint, pathComponents: paths, parameter: .get(listParams))
    }
    
    @discardableResult
    func loadPreviousPage(using client: APIClient, count: Int? = nil, callback: @escaping (Failable<[TItem]>) -> Void) -> APIRequest<TItem.ListEndpoint.Result>? {
        let operation = makeLoadPreviousPageOperation(count: count)
        
        let requestCallback: TItem.ListRequest.Callback = { [weak self] result in
            guard let list = self else { return }
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

public extension List where TItem: OmiseLocatableObject & OmiseIdentifiableObject & OmiseCreatableObject & Listable  {
    public func makeRefreshCurrentDataOperation() -> TItem.ListEndpoint {
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
            case .fail(let error):
                callback(.fail(error))
            }
        }
        
        return client.requestToEndpoint(operation, callback: requestCallback)
    }
}

public extension List where TItem: OmiseResourceObject & Listable {
    public func loadNextPage(using client: APIClient, count: Int? = nil, callback: @escaping (Failable<[TItem]>) -> Void) {
        loadNextPage(using: client, count: count) { (result) in
            switch result {
            case .success(let addedValues):
                callback(.success(addedValues))
            case .fail(let error):
                callback(.fail(error))
            }
        }
    }
    
    public func loadPreviousPage(using client: APIClient, count: Int? = nil, callback: @escaping (Failable<[TItem]>) -> Void) {
        loadPreviousPage(using: client, count: count) { (result) in
            switch result {
            case .success(let addedValues):
                callback(.success(addedValues))
            case .fail(let error):
                callback(.fail(error))
            }
        }
    }
}



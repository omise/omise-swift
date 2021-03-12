import Foundation

public protocol Listable {}

public struct ListParams: APIURLQuery {
    public var from: Date?
    public var to: Date?
    public var offset: Int?
    public var limit: Int?
    public var order: Ordering?
    
    public init(
        from: Date? = nil,
        to: Date? = nil,
        offset: Int? = nil,
        limit: Int? = nil,
        order: Ordering? = nil
    ) {
        self.from = from
        self.to = to
        self.offset = offset
        self.limit = limit
        self.order = order
    }
}

public extension Listable where Self: OmiseLocatableObject {
    typealias ListEndpoint = ListAPIEndpoint<Self>
    typealias ListRequest = ListAPIRequest<Self>
}

public extension OmiseAPIPrimaryObject where Self: Listable {
    @discardableResult
    static func listEndpoint(with params: ListParams?) -> ListEndpoint {
        return ListEndpoint(
            pathComponents: makeResourcePaths(),
            method: .get,
            query: params)
    }
    
    @discardableResult
    static func list(
        using client: APIClient,
        params: ListParams? = nil,
        callback: ListRequest.Callback?
    ) -> ListRequest? {
        let endpoint = self.listEndpoint(with: params)
        return client.request(to: endpoint, callback: callback)
    }
    
    @discardableResult
    static func list(
        using client: APIClient,
        listParams: ListParams? = nil,
        callback: @escaping (APIResult<List<Self>>) -> Void
    ) -> ListRequest? {
        let endpoint = self.listEndpoint(with: listParams)
        
        let requestCallback: ListRequest.Callback = { result in
            let callbackResult = result.map {
                List(listEndpoint: endpoint, list: $0)
            }
            callback(callbackResult)
        }
        
        return client.request(to: endpoint, callback: requestCallback)
    }
}

public extension List {
    func makeLoadNextPageOperation(count: Int?) -> TItem.ListEndpoint {
        guard total > 0 else {
            return initialEndpoint
        }
        let listParams = ListParams(
            offset: loadedIndices.last?.advanced(by: 1) ?? 0,
            limit: count ?? limit,
            order: order)
        
        return TItem.ListEndpoint(
            endpoint: initialEndpoint.endpoint,
            pathComponents: initialEndpoint.pathComponents,
            method: .get,
            query: listParams)
    }
    
    @discardableResult
    func loadNextPage(
        using client: APIClient,
        count: Int? = nil,
        callback: @escaping (APIResult<[TItem]>) -> Void
    ) -> TItem.ListRequest? {
        let operation = makeLoadNextPageOperation(count: count)
        
        let requestCallback: TItem.ListRequest.Callback = { [weak self] result in
            guard let list = self else { return }
            let callbackResult = result.map { list.insert(from: $0) }
            callback(callbackResult)
        }
        
        return client.request(to: operation, callback: requestCallback)
    }
    
    func makeLoadPreviousPageOperation(count: Int?) -> TItem.ListEndpoint {
        guard total > 0 else {
            return initialEndpoint
        }
        let listParams = ListParams(
            offset: loadedFirstIndex.advanced(by: -limit),
            limit: count ?? limit,
            order: order)
        
        return TItem.ListEndpoint(
            endpoint: initialEndpoint.endpoint,
            pathComponents: initialEndpoint.pathComponents,
            method: .get,
            query: listParams)
    }
    
    @discardableResult
    func loadPreviousPage(
        using client: APIClient,
        count: Int? = nil,
        callback: @escaping (APIResult<[TItem]>) -> Void
    ) -> TItem.ListRequest? {
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
        
        return client.request(to: operation, callback: requestCallback)
    }
}

public extension List where TItem: OmiseCreatedObject {
    func makeRefreshCurrentDataOperation() -> TItem.ListEndpoint {
        guard total > 0 else {
            return initialEndpoint
        }
        
        let listParams: ListParams
        
        if let from = data.last?.createdDate, order == .reverseChronological {
            listParams = ListParams(from: from, limit: 100, order: order)
        } else if let to = data.first?.createdDate, order == .chronological {
            listParams = ListParams(to: to, limit: 100, order: order)
        } else {
            listParams = ListParams(limit: limit > 0 ? limit : nil, order: order)
        }
        
        return TItem.ListEndpoint(
            endpoint: initialEndpoint.endpoint,
            pathComponents: initialEndpoint.pathComponents,
            method: .get,
            query: listParams)
    }
    
    @discardableResult
    func refreshData(
        using client: APIClient,
        callback: @escaping (APIResult<[TItem]>) -> Void
    ) -> TItem.ListRequest? {
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
        
        return client.request(to: operation, callback: requestCallback)
    }
}

public extension APIClient {
    func list<T: OmiseAPIPrimaryObject & Listable>(
        _ type: T.Type,
        callback: @escaping T.ListRequest.Callback
    ) -> T.ListRequest? {
        return T.list(using: self, callback: callback)
    }
}

public extension OmiseAPIChildObject where Self: OmiseLocatableObject & Listable {
    @discardableResult
    static func listEndpointWith(parent: Parent, params: ListParams?) -> ListEndpoint {
        return ListEndpoint(
            pathComponents: makeResourcePathsWith(parent: parent),
            method: .get,
            query: params)
    }
    
    @discardableResult
    static func list(
        using client: APIClient,
        parent: Parent,
        params: ListParams? = nil,
        callback: ListRequest.Callback?
    ) -> ListRequest? {
        let endpoint = self.listEndpointWith(parent: parent, params: params)
        return client.request(to: endpoint, callback: callback)
    }
    
    @discardableResult
    static func list(
        using client: APIClient,
        parent: Parent,
        listParams: ListParams? = nil,
        callback: @escaping (APIResult<List<Self>>) -> Void
    ) -> ListRequest? {
        let endpoint = self.listEndpointWith(parent: parent, params: listParams)
        
        let requestCallback: ListRequest.Callback = { result in
            let callbackResult = result.map {
                List(listEndpoint: endpoint, list: $0)
            }
            callback(callbackResult)
        }
        
        return client.request(to: endpoint, callback: requestCallback)
    }
}

public extension OmiseAPIPrimaryObject where Self: OmiseResourceObject {
    func listEndpoint<Children: OmiseAPIChildObject & OmiseLocatableObject & OmiseIdentifiableObject>(
        keyPath: KeyPath<Self, ListProperty<Children>>,
        params: ListParams?
    ) -> ListAPIEndpoint<Children> where Children.Parent == Self {
        return ListAPIEndpoint<Children>(
            pathComponents: Children.makeResourcePathsWith(parent: self),
            method: .get,
            query: params)
    }
    
    @discardableResult
    func list<Children: OmiseAPIChildObject & OmiseLocatableObject & OmiseIdentifiableObject>(
        keyPath: KeyPath<Self, ListProperty<Children>>,
        using client: APIClient,
        params: ListParams? = nil,
        callback: ListAPIRequest<Children>.Callback?
    ) -> ListAPIRequest<Children>? where Children.Parent == Self {
        let endpoint = self.listEndpoint(keyPath: keyPath, params: params)
        return client.request(to: endpoint, callback: callback)
    }
}

public extension OmiseAPIPrimaryObject where Self: OmiseIdentifiableObject {
    func listEndpoint<Children: OmiseLocatableObject>(
        keyPath: KeyPath<Self, ListProperty<Children>>,
        params: ListParams?
    ) -> ListAPIEndpoint<Children> {
        return ListAPIEndpoint<Children>(
            pathComponents: Self.makeResourcePathsWith(parent: self, keyPath: keyPath),
            method: .get,
            query: params)
    }
    
    @discardableResult
    func list<Children: OmiseLocatableObject>(
        keyPath: KeyPath<Self, ListProperty<Children>>,
        using client: APIClient,
        params: ListParams? = nil,
        callback: ListAPIRequest<Children>.Callback?
    ) -> ListAPIRequest<Children>? {
        let endpoint = self.listEndpoint(keyPath: keyPath, params: params)
        return client.request(to: endpoint, callback: callback)
    }
}

extension OmiseAPIPrimaryObject where Self: OmiseIdentifiableObject {
    static func makeResourcePathsWith<Children: OmiseLocatableObject>(
        parent: Self,
        keyPath: KeyPath<Self, ListProperty<Children>>
    ) -> [String] {
        return [Self.resourcePath, parent.id.idString, Children.resourcePath]
    }
}

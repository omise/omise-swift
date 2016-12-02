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
    
    @discardableResult
    public static func listOperation(_ parent: ResourceObject?, params: ListParams?) -> ListOperation {
        return ListOperation(
            endpoint: info.endpoint,
            method: "GET",
            paths: makeResourcePathsWith(context: self, parent: parent),
            params: params
        )
    }
    
    @discardableResult
    public static func list(using given: Client? = nil, parent: ResourceObject? = nil, params: ListParams? = nil, callback: ListOperation.Callback?) -> Request<ListOperation.Result>? {
        guard checkParent(withContext: self, parent: parent) else {
            return nil
        }
        
        let operation = self.listOperation(parent, params: params)
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
    
    @discardableResult
    public static func list(using given: Client? = nil, parent: ResourceObject? = nil, listParams: ListParams? = nil, callback: @escaping (Failable<List<Self>>) -> Void) -> Request<ListOperation.Result>? {
        guard checkParent(withContext: self, parent: parent) else {
            return nil
        }
        
        let operation = self.listOperation(parent, params: listParams)
        let client = resolveClient(given: given)
        
        let requestCallback: ListOperation.Callback = { result in
            let callbackResult = result.map({
                List(endpoint: operation.endpoint, paths: operation.pathComponents, order: listParams?.order, list: $0)
            })
            callback(callbackResult)
        }
        
        return client.call(operation, callback: requestCallback)
    }
    
    public static func makeLoadNextPageOperation(list: List<Self>, count: Int?) -> ListOperation {
        let listParams = ListParams()
        listParams.order = list.order
        listParams.offset = list.loadedIndices.last?.advanced(by: 1) ?? 0
        listParams.limit = count ?? list.limit
        
        return ListOperation(endpoint: list.endpoint, method: "GET", paths: list.paths, params: listParams)
    }
    
    @discardableResult
    static func loadNextPage(list: List<Self>, using given: Client? = nil, count: Int? = nil, callback: @escaping (Failable<[Self]>) -> Void) -> Request<ListOperation.Result>? {
        let operation = makeLoadNextPageOperation(list: list, count: count)
        let client = resolveClient(given: given)
        
        let requestCallback: ListOperation.Callback = { result in
            let callbackResult = result.map({ list.insert(from: $0) })
            callback(callbackResult)
        }
        
        return client.call(operation, callback: requestCallback)
    }
    
    public static func makeLoadPreviousPageOperation(list: List<Self>, count: Int?) -> ListOperation {
        let listParams = ListParams()
        listParams.order = list.order
        listParams.offset = list.loadedFirstIndex.advanced(by: -list.limit)
        listParams.limit = count ?? list.limit
        
        return ListOperation(endpoint: list.endpoint, method: "GET", paths: list.paths, params: listParams)
    }
    
    @discardableResult
    static func loadPreviousPage(list: List<Self>, using given: Client? = nil, count: Int? = nil, callback: @escaping (Failable<[Self]>) -> Void) -> Request<ListOperation.Result>? {
        let operation = makeLoadPreviousPageOperation(list: list, count: count)
        let client = resolveClient(given: given)
        
        let requestCallback: ListOperation.Callback = { result in
            switch result {
            case .success(let result):
                let insertedData = list.insert(from: result)
                callback(.success(insertedData))
            case .fail(let error):
                callback(.fail(error))
            }
        }
        
        return client.call(operation, callback: requestCallback)
    }
}

extension List where TItem: ResourceObject, TItem: Listable {
    public func loadNextPage(using given: Client? = nil, count: Int? = nil, callback: @escaping (Failable<[TItem]>) -> Void) {
        TItem.loadNextPage(list: self, using: given, count: count) { (result) in
            switch result {
            case .success(let addedValues):
                callback(.success(addedValues))
            case .fail(let error):
                callback(.fail(error))
            }
        }
    }
    
    public func loadPreviousPage(using given: Client? = nil, count: Int? = nil, callback: @escaping (Failable<[TItem]>) -> Void) {
        TItem.loadPreviousPage(list: self, using: given, count: count) { (result) in
            switch result {
            case .success(let addedValues):
                callback(.success(addedValues))
            case .fail(let error):
                callback(.fail(error))
            }
        }
    }
}


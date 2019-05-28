import Foundation


public protocol OmiseAPIChildObject: OmiseLocatableObject & OmiseIdentifiableObject {
    associatedtype Parent: OmiseResourceObject & OmiseAPIPrimaryObject
}

public extension OmiseAPIChildObject where Self: OmiseLocatableObject & OmiseIdentifiableObject {
    typealias RetrieveEndpoint = APIEndpoint<Self>
    typealias RetrieveRequest = APIRequest<Self>
    
    static func retrieveEndpointWith(parent: Parent, id: String) -> RetrieveEndpoint {
        let retrieveParams = RetrieveParams(isExpanded: true)
        return RetrieveEndpoint(
            pathComponents: Self.makeResourcePathsWith(parent: parent, id: id),
            parameter: .get(retrieveParams)
        )
    }
    
    static func retrieve(using client: APIClient, parent: Parent, id: String, callback: @escaping RetrieveRequest.Callback) -> RetrieveRequest? {
        let endpoint = self.retrieveEndpointWith(parent: parent, id: id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

public extension OmiseAPIChildObject where Self: Destroyable {
    typealias DestroyEndpoint = APIEndpoint<Self>
    typealias DestroyRequest = APIRequest<Self>
    
    static func destroyEndpointWith(parent: Parent, id: String) -> DestroyEndpoint {
        return DestroyEndpoint(
            pathComponents: Self.makeResourcePathsWith(parent: parent, id: id),
            parameter: .delete
        )
    }
    
    static func destroy(using client: APIClient, parent: Parent, id: String, callback: @escaping DestroyRequest.Callback) -> DestroyRequest? {
        let endpoint = self.destroyEndpointWith(parent: parent, id: id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}


public extension OmiseAPIChildObject where Self: Updatable {
    typealias UpdateEndpoint = APIEndpoint<Self>
    typealias UpdateRequest = APIRequest<Self>
    
    static func updateEndpointWith(parent: Parent, id: String, params: UpdateParams) -> UpdateEndpoint {
        return UpdateEndpoint(
            pathComponents: Self.makeResourcePathsWith(parent: parent, id: id),
            parameter: .patch(params)
        )
    }
    
    static func update(using client: APIClient, parent: Parent, id: String, params: UpdateParams, callback: @escaping UpdateRequest.Callback) -> UpdateRequest? {
        let endpoint = self.updateEndpointWith(parent: parent, id: id, params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}



public extension OmiseAPIChildObject where Self: Creatable {
    typealias CreateEndpoint = APIEndpoint<Self>
    typealias CreateRequest = APIRequest<Self>
    
    static func createEndpointWith(parent: Parent, params: CreateParams) -> APIEndpoint<Self> {
        return APIEndpoint<Self>(
            pathComponents: Self.makeResourcePathsWith(parent: parent),
            parameter: .post(params)
        )
    }
    
    static func create(using client: APIClient, parent: Parent, params: CreateParams, callback: @escaping APIRequest<Self>.Callback) -> APIRequest<Self>? {
        let endpoint = self.createEndpointWith(parent: parent, params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}


public extension OmiseAPIChildObject where Self : OmiseLocatableObject & Listable {
    typealias ListEndpoint = APIEndpoint<ListProperty<Self>>
    typealias ListRequest = APIRequest<ListProperty<Self>>
    
    @discardableResult
    static func listEndpointWith(parent: Parent, params: ListParams?) -> ListEndpoint {
        return ListEndpoint(
            pathComponents: makeResourcePathsWith(parent: parent),
            parameter: .get(params)
        )
    }
    
    @discardableResult
    static func list(using client: APIClient, parent: Parent, params: ListParams? = nil, callback: ListRequest.Callback?) -> ListRequest? {
        let endpoint = self.listEndpointWith(parent: parent, params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    @discardableResult
    static func list(using client: APIClient, parent: Parent, listParams: ListParams? = nil, callback: @escaping (APIResult<List<Self>>) -> Void) -> ListRequest? {
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

extension OmiseAPIPrimaryObject where Self: OmiseResourceObject  {
    func listEndpoint<Children: OmiseAPIChildObject & OmiseLocatableObject & OmiseIdentifiableObject>(keyPath: KeyPath<Self, ListProperty<Children>>, params: ListParams?)
        -> APIEndpoint<ListProperty<Children>> where Children.Parent == Self {
            return APIEndpoint<ListProperty<Children>>(
                pathComponents: Children.makeResourcePathsWith(parent: self),
                parameter: .get(params)
            )
    }
    
    @discardableResult
    func list<Children: OmiseAPIChildObject & OmiseLocatableObject & OmiseIdentifiableObject>
        (keyPath: KeyPath<Self, ListProperty<Children>>,
         using client: APIClient,
         params: ListParams? = nil,
         callback: APIRequest<ListProperty<Children>>.Callback?) -> APIRequest<ListProperty<Children>>? where Children.Parent == Self {
        let endpoint = self.listEndpoint(keyPath: keyPath, params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

extension OmiseAPIPrimaryObject where Self: OmiseIdentifiableObject {
    func listEndpoint<Children: OmiseLocatableObject & OmiseIdentifiableObject>(keyPath: KeyPath<Self, ListProperty<Children>>, params: ListParams?)
        -> APIEndpoint<ListProperty<Children>> {
            return APIEndpoint<ListProperty<Children>>(
                pathComponents: Self.makeResourcePathsWith(parent: self, keyPath: keyPath),
                parameter: .get(params)
            )
    }
    
    @discardableResult
    func list<Children: OmiseLocatableObject & OmiseIdentifiableObject>
        (keyPath: KeyPath<Self, ListProperty<Children>>,
         using client: APIClient,
         params: ListParams? = nil,
         callback: APIRequest<ListProperty<Children>>.Callback?) -> APIRequest<ListProperty<Children>>? {
        let endpoint = self.listEndpoint(keyPath: keyPath, params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    static func makeResourcePathsWith<Children: OmiseLocatableObject>
        (parent: Self, keyPath: KeyPath<Self, ListProperty<Children>>) -> [String] {
        var paths = [String]()
        
        paths = [Self.resourceInfo.path, parent.id]
        paths.append(Children.resourceInfo.path)
        return paths
    }
}


extension OmiseAPIChildObject where Self: OmiseLocatableObject & OmiseIdentifiableObject {
    static func makeResourcePathsWith(parent: Parent, id: String? = nil) -> [String] {
        var paths = [String]()
        
        paths = [type(of: parent).resourceInfo.path, parent.id]
        paths.append(self.resourceInfo.path)
        if let id = id {
            paths.append(id)
        }
        
        return paths
    }
}


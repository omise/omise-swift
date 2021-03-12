import Foundation

public protocol Creatable {
    associatedtype CreateParams: APIQuery
}

public extension Creatable where Self: OmiseObject {
    typealias CreateEndpoint = APIEndpoint<Self.CreateParams, Self>
    typealias CreateRequest = APIRequest<Self.CreateParams, Self>
}

public extension OmiseAPIPrimaryObject where Self: Creatable {
    static func createEndpoint(with params: CreateParams) -> CreateEndpoint {
        return CreateEndpoint(
            pathComponents: Self.makeResourcePaths(),
            method: .post,
            query: params)
    }
    
    static func create(
        using client: APIClient,
        params: CreateParams,
        callback: @escaping CreateRequest.Callback
    ) -> CreateRequest? {
        let endpoint = self.createEndpoint(with: params)
        return client.request(to: endpoint, callback: callback)
    }
}

public extension APIClient {
    func create<T: OmiseAPIPrimaryObject & Creatable>(
        params: T.CreateParams,
        callback: @escaping T.CreateRequest.Callback
    ) -> T.CreateRequest? {
        return T.create(using: self, params: params, callback: callback)
    }
}

public extension OmiseAPIChildObject where Self: Creatable {
    static func createEndpointWith(parent: Parent, params: CreateParams) -> Self.CreateEndpoint {
        return Self.CreateEndpoint(
            pathComponents: Self.makeResourcePathsWith(parent: parent),
            method: .post,
            query: params)
    }
    
    static func create(
        using client: APIClient,
        parent: Parent,
        params: CreateParams,
        callback: @escaping Self.CreateRequest.Callback
    ) -> Self.CreateRequest? {
        let endpoint = self.createEndpointWith(parent: parent, params: params)
        return client.request(to: endpoint, callback: callback)
    }
}

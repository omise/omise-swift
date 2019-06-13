import Foundation

public protocol Creatable {
    associatedtype CreateParams: APIQuery
}

public extension OmiseAPIPrimaryObject where Self: Creatable {
    typealias CreateEndpoint = APIEndpoint<Self>
    typealias CreateRequest = APIRequest<Self>
    
    static func createEndpoint(with params: CreateParams) -> CreateEndpoint {
        return CreateEndpoint(
            pathComponents: Self.makeResourcePaths(),
            parameter: .post(params))
    }
    
    static func create(
        using client: APIClient, params: CreateParams, callback: @escaping CreateRequest.Callback
        ) -> CreateRequest? {
        let endpoint = self.createEndpoint(with: params)
        return client.request(to: endpoint, callback: callback)
    }
}


public extension APIClient {
    func create<T: OmiseAPIPrimaryObject & Creatable>(
        params: T.CreateParams, callback: @escaping T.CreateRequest.Callback
        ) -> T.CreateRequest? {
        return T.create(using: self, params: params, callback: callback)
    }
}


public extension OmiseAPIChildObject where Self: Creatable {
    typealias CreateEndpoint = APIEndpoint<Self>
    typealias CreateRequest = APIRequest<Self>
    
    static func createEndpointWith(parent: Parent, params: CreateParams) -> APIEndpoint<Self> {
        return APIEndpoint<Self>(
            pathComponents: Self.makeResourcePathsWith(parent: parent),
            parameter: .post(params))
    }
    
    static func create(
        using client: APIClient, parent: Parent, params: CreateParams, callback: @escaping APIRequest<Self>.Callback
        ) -> APIRequest<Self>? {
        let endpoint = self.createEndpointWith(parent: parent, params: params)
        return client.request(to: endpoint, callback: callback)
    }
}



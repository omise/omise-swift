import Foundation

public protocol Creatable {
    associatedtype CreateParams: APIQuery
}

public extension OmiseAPIPrimaryObject where Self: Creatable {
    typealias CreateEndpoint = APIEndpoint<Self>
    typealias CreateRequest = APIRequest<Self>
    
    static func createEndpointWith(params: CreateParams) -> CreateEndpoint {
        return CreateEndpoint(
            pathComponents: Self.makeResourcePaths(),
            parameter: .post(params)
        )
    }
    
    static func create(using client: APIClient, params: CreateParams, callback: @escaping CreateRequest.Callback) -> CreateRequest? {
        let endpoint = self.createEndpointWith(params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}


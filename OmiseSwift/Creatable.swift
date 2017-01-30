import Foundation

public protocol Creatable {
    associatedtype CreateParams: APIParams
}

public extension Creatable where Self: OmiseLocatableObject {
    public typealias CreateEndpoint = APIEndpoint<Self>
    public typealias CreateRequest = APIRequest<Self>
    
    public static func createEndpointWith(parent: OmiseResourceObject?, params: CreateParams) -> CreateEndpoint {
        return CreateEndpoint(
            endpoint: resourceInfo.endpoint,
            method: "POST",
            pathComponents: Self.makeResourcePathsWithParent(parent),
            params: params
        )
    }
    
    public static func create(using client: APIClient, parent: OmiseResourceObject? = nil, params: CreateParams, callback: @escaping CreateRequest.Callback) -> CreateRequest? {
        guard Self.verifyParent(parent) else {
            return nil
        }
        
        let endpoint = self.createEndpointWith(parent: parent, params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

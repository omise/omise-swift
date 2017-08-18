import Foundation

public protocol Creatable {
    associatedtype CreateParams: APIQuery
}

public extension Creatable where Self: OmiseLocatableObject {
    public typealias CreateEndpoint = APIEndpoint<Self>
    public typealias CreateRequest = APIRequest<Self>
    
    public static func createEndpointWith(parent: OmiseResourceObject?, params: CreateParams) -> CreateEndpoint {
        return CreateEndpoint(
            pathComponents: Self.makeResourcePathsWithParent(parent),
            parameter: .post(params)
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

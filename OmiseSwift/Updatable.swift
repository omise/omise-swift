import Foundation

public protocol Updatable {
    associatedtype UpdateParams: APIParams
}

public extension Updatable where Self: OmiseResourceObject {
    public typealias UpdateEndpoint = APIEndpoint<Self>
    public typealias UpdateRequest = APIRequest<Self>
    
    public static func updateEndpointWith(parent: OmiseResourceObject?, id: String, params: UpdateParams) -> UpdateEndpoint {
        return UpdateEndpoint(
            method: "PATCH",
            pathComponents: makeResourcePathsWithParent(parent, id: id),
            params: params
        )
    }
    
    public static func update(using client: APIClient, parent: OmiseResourceObject? = nil, id: String, params: UpdateParams, callback: @escaping UpdateRequest.Callback) -> UpdateRequest? {
        guard verifyParent(parent) else {
            return nil
        }
        
        let endpoint = self.updateEndpointWith(parent: parent, id: id, params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

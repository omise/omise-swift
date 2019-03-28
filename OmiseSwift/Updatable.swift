import Foundation

public protocol Updatable {
    associatedtype UpdateParams: APIJSONQuery
}

public extension Updatable where Self: OmiseResourceObject {
    typealias UpdateEndpoint = APIEndpoint<Self>
    typealias UpdateRequest = APIRequest<Self>
    
    static func updateEndpointWith(parent: OmiseResourceObject?, id: String, params: UpdateParams) -> UpdateEndpoint {        return UpdateEndpoint(
            pathComponents: makeResourcePathsWithParent(parent, id: id),
            parameter: .patch(params)
        )
    }
    
    static func update(using client: APIClient, parent: OmiseResourceObject? = nil, id: String, params: UpdateParams, callback: @escaping UpdateRequest.Callback) -> UpdateRequest? {
        guard verifyParent(parent) else {
            return nil
        }
        
        let endpoint = self.updateEndpointWith(parent: parent, id: id, params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

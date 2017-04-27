import Foundation

public protocol Retrievable {}

public struct RetrieveParams: APIParams {
    public var isExpanded: Bool = false
    
    public var json: JSONAttributes {
        return [
            "expand": isExpanded,
        ]
    }
}

public extension Retrievable where Self: OmiseLocatableObject {
    public typealias RetrieveEndpoint = APIEndpoint<Self>
    public typealias RetrieveRequest = APIRequest<Self>
    
    public static func retrieveEndpointWith(parent: OmiseResourceObject?, id: String) -> RetrieveEndpoint {
        let retrieveParams = RetrieveParams(isExpanded: true)
        return RetrieveEndpoint(
            method: "GET",
            pathComponents: makeResourcePathsWithParent(parent, id: id),
            params: retrieveParams
        )
    }
    
    public static func retrieve(using client: APIClient, parent: OmiseResourceObject? = nil, id: String, callback: @escaping RetrieveRequest.Callback) -> RetrieveRequest? {
        guard verifyParent(parent) else {
            return nil
        }
        
        let endpoint = self.retrieveEndpointWith(parent: parent, id: id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

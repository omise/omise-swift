import Foundation

public protocol SingletonRetrievable {}

public extension SingletonRetrievable where Self: OmiseLocatableObject {
    public typealias SingletonRetrieveEndpoint = APIEndpoint<Self>
    public typealias RetrieveRequest = APIRequest<Self>
    
    public static func retrieveEndpointWithParent(_ parent: OmiseResourceObject?) -> SingletonRetrieveEndpoint {
        return SingletonRetrieveEndpoint(
            method: "GET",
            pathComponents: makeResourcePathsWithParent(parent),
            params: nil
        )
    }
    
    public static func retrieve(using client: APIClient, parent: OmiseResourceObject? = nil, callback: RetrieveRequest.Callback?) -> RetrieveRequest? {
        guard verifyParent(parent) else {
            return nil
        }
        
        let endpoint = self.retrieveEndpointWithParent(parent)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

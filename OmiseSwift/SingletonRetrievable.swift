import Foundation

public protocol SingletonRetrievable {}

public extension SingletonRetrievable where Self: OmiseResourceObject {
    public typealias SingletonRetrieveEndpoint = APIEndpoint<Self>
    public typealias RetrieveRequest = Request<Self>
    
    public static func retrieveEndpoint(_ parent: OmiseResourceObject?) -> SingletonRetrieveEndpoint {
        return SingletonRetrieveEndpoint(
            endpoint: resourceInfo.endpoint,
            method: "GET",
            pathComponents: makeResourcePathsWithParent(parent),
            params: nil
        )
    }
    
    public static func retrieve(using client: APIClient, parent: OmiseResourceObject? = nil, callback: RetrieveRequest.Callback?) -> RetrieveRequest? {
        guard verifyParent(parent) else {
            return nil
        }
        
        let endpoint = self.retrieveEndpoint(parent)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

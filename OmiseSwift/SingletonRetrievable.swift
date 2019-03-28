import Foundation

public protocol SingletonRetrievable {}

public extension SingletonRetrievable where Self: OmiseLocatableObject {
    typealias SingletonRetrieveEndpoint = APIEndpoint<Self>
    typealias RetrieveRequest = APIRequest<Self>
    
    static func retrieveEndpointWithParent(_ parent: OmiseResourceObject?) -> SingletonRetrieveEndpoint {
        return SingletonRetrieveEndpoint(
            pathComponents: makeResourcePathsWithParent(parent),
            parameter: .get(nil)
        )
    }
    
    static func retrieve(using client: APIClient, parent: OmiseResourceObject? = nil, callback: RetrieveRequest.Callback?) -> RetrieveRequest? {
        guard verifyParent(parent) else {
            return nil
        }
        
        let endpoint = self.retrieveEndpointWithParent(parent)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

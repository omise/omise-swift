import Foundation

public protocol SingletonRetrievable {}

public extension SingletonRetrievable where Self: OmiseLocatableObject {
    typealias SingletonRetrieveEndpoint = APIEndpoint<Self>
    typealias RetrieveRequest = APIRequest<Self>
    
    static func retrieveEndpoint() -> SingletonRetrieveEndpoint {
        let retrieveParams = RetrieveParams(isExpanded: true)
        return SingletonRetrieveEndpoint(
            pathComponents: [Self.resourcePath],
            parameter: .get(retrieveParams)
        )
    }
    
    static func retrieve(using client: APIClient, callback: @escaping RetrieveRequest.Callback) -> RetrieveRequest? {
        let endpoint = self.retrieveEndpoint()
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

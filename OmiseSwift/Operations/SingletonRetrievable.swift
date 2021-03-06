import Foundation

public protocol SingletonRetrievable {}

public extension SingletonRetrievable where Self: OmiseLocatableObject {
    typealias SingletonRetrieveEndpoint = APIEndpoint<RetrieveParams, Self>
    typealias SingletonRetrieveRequest = APIRequest<RetrieveParams, Self>
    
    static func retrieveEndpoint() -> SingletonRetrieveEndpoint {
        let retrieveParams = RetrieveParams(isExpanded: true)
        return SingletonRetrieveEndpoint(
            pathComponents: [Self.resourcePath],
            method: .get,
            query: retrieveParams)
    }
    
    static func retrieve(
        using client: APIClient, callback: @escaping SingletonRetrieveRequest.Callback
        ) -> SingletonRetrieveRequest? {
        let endpoint = self.retrieveEndpoint()
        return client.request(to: endpoint, callback: callback)
    }
}

public extension APIClient {
    func retrieve<T: OmiseAPIPrimaryObject & SingletonRetrievable>(
        _ type: T.Type, callback: @escaping T.SingletonRetrieveRequest.Callback
        ) -> T.SingletonRetrieveRequest? {
        return T.retrieve(using: self, callback: callback)
    }
}

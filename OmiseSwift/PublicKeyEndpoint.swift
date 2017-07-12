import Foundation

public extension Key where Kind == PublicKey {
    public typealias PublicKeyRetrieveEndpoint = APIEndpoint<Key<PublicKey>>
    public typealias PublicKeyRetrieveRequest = APIRequest<Key<PublicKey>>
    
    
    public static func retrivePublicKeyEndpoint() -> PublicKeyRetrieveEndpoint {
        return APIEndpoint(
            pathComponents: ["keys", "public"], parameter: .get(nil)
        )
    }
    
    public static func retrievePublicKeyUsingClient(_ client: APIClient, callback: PublicKeyRetrieveRequest.Callback?) -> PublicKeyRetrieveRequest? {
        let endpoint = self.retrivePublicKeyEndpoint()
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}


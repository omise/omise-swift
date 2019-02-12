import Foundation

public protocol Retrievable {}

public struct RetrieveParams: APIJSONQuery {
    public var isExpanded: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case isExpanded = "expand"
    }
}

public extension Retrievable where Self: OmiseLocatableObject & OmiseIdentifiableObject {
    typealias RetrieveEndpoint = APIEndpoint<Self>
    typealias RetrieveRequest = APIRequest<Self>
    
    static func retrieveEndpointWith(parent: OmiseResourceObject?, id: String) -> RetrieveEndpoint {
        let retrieveParams = RetrieveParams(isExpanded: true)
        return RetrieveEndpoint(
            pathComponents: makeResourcePathsWithParent(parent, id: id),
            parameter: .get(retrieveParams)
        )
    }
    
    static func retrieve(using client: APIClient, parent: OmiseResourceObject? = nil, id: String, callback: @escaping RetrieveRequest.Callback) -> RetrieveRequest? {
        guard verifyParent(parent) else {
            return nil
        }
        
        let endpoint = self.retrieveEndpointWith(parent: parent, id: id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

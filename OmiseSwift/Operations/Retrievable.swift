import Foundation

public protocol Retrievable {}

public struct RetrieveParams: APIJSONQuery {
    public var isExpanded: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case isExpanded = "expand"
    }
}

public extension OmiseAPIPrimaryObject where Self: Retrievable & OmiseIdentifiableObject {
    typealias RetrieveEndpoint = APIEndpoint<Self>
    typealias RetrieveRequest = APIRequest<Self>
    
    static func retrieveEndpoint(with id: DataID<Self>) -> RetrieveEndpoint {
        let retrieveParams = RetrieveParams(isExpanded: true)
        return RetrieveEndpoint(
            pathComponents: Self.makeResourcePaths(id: id),
            parameter: .get(retrieveParams))
    }
    
    static func retrieve(using client: APIClient, id: DataID<Self>, callback: @escaping RetrieveRequest.Callback) -> RetrieveRequest? {
        let endpoint = self.retrieveEndpoint(with: id)
        return client.request(to: endpoint, callback: callback)
    }
}


public extension APIClient {
    func retrieve<T: OmiseAPIPrimaryObject & Retrievable>(dataID: DataID<T>, callback: @escaping T.RetrieveRequest.Callback) -> T.RetrieveRequest? {
        return T.retrieve(using: self, id: dataID, callback: callback)
    }
}


public extension OmiseAPIChildObject where Self: OmiseLocatableObject & OmiseIdentifiableObject {
    typealias RetrieveEndpoint = APIEndpoint<Self>
    typealias RetrieveRequest = APIRequest<Self>
    
    static func retrieveEndpointWith(parent: Parent, id: DataID<Self>) -> RetrieveEndpoint {
        let retrieveParams = RetrieveParams(isExpanded: true)
        return RetrieveEndpoint(
            pathComponents: Self.makeResourcePathsWith(parent: parent, id: id),
            parameter: .get(retrieveParams))
    }
    
    static func retrieve(using client: APIClient, parent: Parent, id: DataID<Self>, callback: @escaping RetrieveRequest.Callback) -> RetrieveRequest? {
        let endpoint = self.retrieveEndpointWith(parent: parent, id: id)
        return client.request(to: endpoint, callback: callback)
    }
}


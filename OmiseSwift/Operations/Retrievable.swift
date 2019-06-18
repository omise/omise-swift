import Foundation

public protocol Retrievable {}

public struct RetrieveParams: APIURLQuery {
    public var isExpanded: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case isExpanded = "expand"
    }
}

public extension Retrievable where Self: OmiseIdentifiableObject {
    typealias RetrieveEndpoint = APIEndpoint<RetrieveParams, Self>
    typealias RetrieveRequest = APIRequest<RetrieveParams, Self>
}

public extension OmiseAPIPrimaryObject where Self: Retrievable & OmiseIdentifiableObject {
    static func retrieveEndpoint(for id: DataID<Self>) -> RetrieveEndpoint {
        let retrieveParams = RetrieveParams(isExpanded: true)
        return RetrieveEndpoint(
            pathComponents: Self.makeResourcePaths(id: id),
            method: .get, query: retrieveParams)
    }
    
    static func retrieve(
        using client: APIClient, id: DataID<Self>, 
        callback: @escaping RetrieveRequest.Callback
        ) -> RetrieveRequest? {
        let endpoint = self.retrieveEndpoint(for: id)
        return client.request(to: endpoint, callback: callback)
    }
}


public extension APIClient {
    func retrieve<T: OmiseAPIPrimaryObject & Retrievable>(
        dataID: DataID<T>, callback: @escaping T.RetrieveRequest.Callback
        ) -> T.RetrieveRequest? {
        return T.retrieve(using: self, id: dataID, callback: callback)
    }
}


public extension OmiseAPIChildObject where Self: OmiseLocatableObject & OmiseIdentifiableObject & Retrievable {    
    static func retrieveEndpointWith(parent: Parent, id: DataID<Self>) -> RetrieveEndpoint {
        let retrieveParams = RetrieveParams(isExpanded: true)
        return RetrieveEndpoint(
            pathComponents: Self.makeResourcePathsWith(parent: parent, id: id),
            method: .get, query: retrieveParams)
    }
    
    static func retrieve(
        using client: APIClient, parent: Parent, id: DataID<Self>, 
        callback: @escaping RetrieveRequest.Callback
        ) -> RetrieveRequest? {
        let endpoint = self.retrieveEndpointWith(parent: parent, id: id)
        return client.request(to: endpoint, callback: callback)
    }
}


import Foundation


public protocol Destroyable {
    var isDeleted: Bool { get }
}

public extension OmiseAPIPrimaryObject where Self: Destroyable & OmiseIdentifiableObject {
    typealias DestroyEndpoint = APIEndpoint<Self>
    typealias DestroyRequest = APIRequest<Self>
    
    static func destroyEndpoint(with id: DataID<Self>) -> DestroyEndpoint {
        return DestroyEndpoint(
            pathComponents: Self.makeResourcePaths(id: id),
            parameter: .delete
        )
    }
    
    static func destroy(using client: APIClient, id: DataID<Self>, callback: @escaping DestroyRequest.Callback) -> DestroyRequest? {
        let endpoint = self.destroyEndpoint(with: id)
        return client.request(to: endpoint, callback: callback)
    }
}

public extension APIClient {
    func delete<T: OmiseAPIPrimaryObject & Destroyable>(dataID: DataID<T>, callback: @escaping T.DestroyRequest.Callback) -> T.DestroyRequest? {
        return T.destroy(using: self, id: dataID, callback: callback)
    }
}


public extension OmiseAPIChildObject where Self: Destroyable & OmiseIdentifiableObject {
    typealias DestroyEndpoint = APIEndpoint<Self>
    typealias DestroyRequest = APIRequest<Self>
    
    static func destroyEndpointWith(parent: Parent, id: DataID<Self>) -> DestroyEndpoint {
        return DestroyEndpoint(
            pathComponents: Self.makeResourcePathsWith(parent: parent, id: id),
            parameter: .delete
        )
    }
    
    static func destroy(using client: APIClient, parent: Parent, id: DataID<Self>, callback: @escaping DestroyRequest.Callback) -> DestroyRequest? {
        let endpoint = self.destroyEndpointWith(parent: parent, id: id)
        return client.request(to: endpoint, callback: callback)
    }
}



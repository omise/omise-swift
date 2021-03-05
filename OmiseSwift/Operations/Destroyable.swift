import Foundation

public protocol Destroyable {
    var isDeleted: Bool { get }
}

public extension Destroyable where Self: OmiseIdentifiableObject {
    typealias DestroyEndpoint = APIEndpoint<NoAPIQuery, Self>
    typealias DestroyRequest = APIRequest<NoAPIQuery, Self>
}

public extension OmiseAPIPrimaryObject where Self: Destroyable & OmiseIdentifiableObject {
    static func destroyEndpoint(for id: DataID<Self>) -> DestroyEndpoint {
        return DestroyEndpoint(
            pathComponents: Self.makeResourcePaths(id: id),
            method: .delete)
    }
    
    static func destroy(
        using client: APIClient,
        id: DataID<Self>,
        callback: @escaping DestroyRequest.Callback
    ) -> DestroyRequest? {
        let endpoint = self.destroyEndpoint(for: id)
        return client.request(to: endpoint, callback: callback)
    }
}

public extension APIClient {
    func delete<T: OmiseAPIPrimaryObject & Destroyable>(
        dataID: DataID<T>,
        callback: @escaping T.DestroyRequest.Callback
        ) -> T.DestroyRequest? {
        return T.destroy(using: self, id: dataID, callback: callback)
    }
}

public extension OmiseAPIChildObject where Self: Destroyable & OmiseIdentifiableObject {
    static func destroyEndpointWith(parent: Parent, id: DataID<Self>) -> DestroyEndpoint {
        return DestroyEndpoint(
            pathComponents: Self.makeResourcePathsWith(parent: parent, id: id),
            method: .delete)
    }
    
    static func destroy(
        using client: APIClient,
        parent: Parent,
        id: DataID<Self>,
        callback: @escaping DestroyRequest.Callback
    ) -> DestroyRequest? {
        let endpoint = self.destroyEndpointWith(parent: parent, id: id)
        return client.request(to: endpoint, callback: callback)
    }
}

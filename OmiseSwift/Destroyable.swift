import Foundation


public protocol Destroyable {
    var isDeleted: Bool { get }
}

public extension OmiseAPIPrimaryObject where Self: Destroyable {
    typealias DestroyEndpoint = APIEndpoint<Self>
    typealias DestroyRequest = APIRequest<Self>
    
    static func destroyEndpointWith(id: String) -> DestroyEndpoint {
        return DestroyEndpoint(
            pathComponents: Self.makeResourcePaths(id: id),
            parameter: .delete
        )
    }
    
    static func destroy(using client: APIClient, id: String, callback: @escaping DestroyRequest.Callback) -> DestroyRequest? {
        let endpoint = self.destroyEndpointWith(id: id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

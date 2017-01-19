import Foundation

public protocol Destroyable {}

public extension Destroyable where Self: OmiseResourceObject {
    public typealias DestroyEndpoint = APIEndpoint<Self>
    public typealias DestroyRequest = APIRequest<Self>
    
    public static func destroyEndpointWithParent(_ parent: OmiseResourceObject?, id: String) -> DestroyEndpoint {
        return DestroyEndpoint(
            endpoint: resourceInfo.endpoint,
            method: "DELETE",
            pathComponents: Self.makeResourcePathsWithParent(parent, id: id),
            params: nil
        )
    }
    
    public static func destroy(using client: APIClient, parent: OmiseResourceObject? = nil, id: String, callback: @escaping DestroyRequest.Callback) -> DestroyRequest? {
        guard Self.verifyParent(parent) else {
            return nil
        }
        
        let endpoint = self.destroyEndpointWithParent(parent, id: id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

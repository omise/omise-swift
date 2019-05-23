import Foundation


public protocol Destroyable {
    var isDeleted: Bool { get }
}

public extension Destroyable where Self: OmiseResourceObject {
    typealias DestroyEndpoint = APIEndpoint<Self>
    typealias DestroyRequest = APIRequest<Self>
    
    static func destroyEndpointWith(parent: OmiseResourceObject?, id: String) -> DestroyEndpoint {
        return DestroyEndpoint(
            pathComponents: Self.makeResourcePathsWithParent(parent, id: id),
            parameter: .delete
        )
    }
    
    static func destroy(using client: APIClient, parent: OmiseResourceObject? = nil, id: String, callback: @escaping DestroyRequest.Callback) -> DestroyRequest? {
        guard Self.verifyParent(parent) else {
            return nil
        }
        
        let endpoint = self.destroyEndpointWith(parent: parent, id: id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

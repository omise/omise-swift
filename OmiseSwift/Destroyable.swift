import Foundation

public struct DeletedObject<DeletedObjectType: Destroyable & OmiseResourceObject>: OmiseLiveModeObject {
    public let isLive: Bool
    public let object: String
    public let id: String
    
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = DeletedObject<DeletedObjectType>.parseOmiseProperties(JSON: json),
            let id = json["id"] as? String,
            let isDeleted = json["deleted"] as? Bool, isDeleted else {
                return nil
        }
        
        (self.object, self.isLive) = omiseObjectProperties
        self.id = id
    }
}

public protocol Destroyable {}

public extension Destroyable where Self: OmiseResourceObject {
    public typealias DestroyEndpoint = APIEndpoint<DeletedObject<Self>>
    public typealias DestroyRequest = APIRequest<DeletedObject<Self>>
    
    public static func destroyEndpointWith(parent: OmiseResourceObject?, id: String) -> DestroyEndpoint {
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
        
        let endpoint = self.destroyEndpointWith(parent: parent, id: id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

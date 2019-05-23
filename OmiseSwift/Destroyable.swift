import Foundation

public struct DeletedObject<DeletedObjectType: Destroyable & OmiseResourceObject>: OmiseLiveModeObject, Equatable, Decodable {
    public let isLiveMode: Bool
    public let object: String
    public let id: String
}

extension DeletedObject {
    private enum CodingKeys: String, CodingKey {
        case object
        case id
        case isLiveMode = "livemode"
    }
}

public protocol Destroyable {}

public extension Destroyable where Self: OmiseResourceObject {
    typealias DestroyEndpoint = APIEndpoint<DeletedObject<Self>>
    typealias DestroyRequest = APIRequest<DeletedObject<Self>>
    
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

import Foundation

public protocol Updatable {
    associatedtype UpdateParams: APIJSONQuery
}

public extension OmiseAPIPrimaryObject where Self: Updatable & OmiseIdentifiableObject {
    typealias UpdateEndpoint = APIEndpoint<Self>
    typealias UpdateRequest = APIRequest<Self>
    
    static func updateEndpointWith(id: DataID<Self>, params: UpdateParams) -> UpdateEndpoint {        return UpdateEndpoint(
            pathComponents: makeResourcePaths(id: id),
            parameter: .patch(params)
        )
    }
    
    static func update(using client: APIClient, id: DataID<Self>, params: UpdateParams, callback: @escaping UpdateRequest.Callback) -> UpdateRequest? {
        let endpoint = self.updateEndpointWith(id: id, params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}


public extension APIClient {
    func update<T: OmiseAPIPrimaryObject & Updatable>(dataID: DataID<T>, params: T.UpdateParams, callback: @escaping T.UpdateRequest.Callback) -> T.UpdateRequest? {
        return T.update(using: self, id: dataID, params: params, callback: callback)
    }
}


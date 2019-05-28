import Foundation


extension Transfer {
    public typealias MarkEndpoint = APIEndpoint<Transfer>
    public typealias MarkRequest = APIRequest<Transfer>
    
    public static func markAsSentEndpointWithID(_ id: String) -> MarkEndpoint {
        return MarkEndpoint(
            pathComponents: [resourceInfo.path, id, "mark_as_sent"],
            parameter: .post(nil)
        )
    }
    
    public static func markAsSent(using client: APIClient, id: String, callback: @escaping MarkRequest.Callback) -> MarkRequest? {
        let endpoint = markAsSentEndpointWithID(id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    public static func markAsPaidEndpointWithID(_ id: String) -> MarkEndpoint {
        return MarkEndpoint(
            pathComponents: [resourceInfo.path, id, "mark_as_paid"],
            parameter: .post(nil)
        )
    }
    
    public static func markAsPaid(using client: APIClient, id: String, callback: @escaping MarkRequest.Callback) -> MarkRequest? {
        let endpoint = markAsPaidEndpointWithID(id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
}


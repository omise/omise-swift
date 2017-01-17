import Foundation


extension Charge {
    public typealias CaptureEndpoint = APIEndpoint<Charge>
    public typealias CaptureRequest = Request<Charge>
    public typealias ReverseEndpoint = APIEndpoint<Charge>
    public typealias ReverseRequest = Request<Charge>
    
    public static func captureEndpoint(id: String) -> CaptureEndpoint {
        return CaptureEndpoint(
            endpoint: resourceInfo.endpoint,
            method: "POST",
            pathComponents: [resourceInfo.path, id, "capture"],
            params: nil
        )
    }
    
    public static func capture(using client: APIClient, id: String, callback: @escaping CaptureRequest.Callback) -> CaptureRequest? {
        let endpoint = captureEndpoint(id: id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    public static func reverseEndpoint(id: String) -> ReverseEndpoint {
        return ReverseEndpoint(
            endpoint: resourceInfo.endpoint,
            method: "POST",
            pathComponents: [resourceInfo.path, id, "reverse"],
            params: nil
        )
    }
    
    public static func reverse(using client: APIClient, id: String, callback: @escaping ReverseRequest.Callback) -> ReverseRequest? {
        let endpoint = reverseEndpoint(id: id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}


import Foundation


extension Charge {
    public typealias CaptureEndpoint = APIEndpoint<Charge>
    public typealias CaptureRequest = APIRequest<Charge>
    public typealias ReverseEndpoint = APIEndpoint<Charge>
    public typealias ReverseRequest = APIRequest<Charge>
    
    public typealias ScheduleListEndpoint = APIEndpoint<ListProperty<Schedule<Charge>>>
    public typealias ScheduleListRequest = APIRequest<ListProperty<Schedule<Charge>>>
    
    public static func captureEndpointWithID(_ id: String) -> CaptureEndpoint {
        return CaptureEndpoint(
            method: "POST",
            pathComponents: [resourceInfo.path, id, "capture"],
            params: nil
        )
    }
    
    public static func capture(using client: APIClient, id: String, callback: @escaping CaptureRequest.Callback) -> CaptureRequest? {
        let endpoint = captureEndpointWithID(id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    public static func reverseEndpointWithID(_ id: String) -> ReverseEndpoint {
        return ReverseEndpoint(
            method: "POST",
            pathComponents: [resourceInfo.path, id, "reverse"],
            params: nil
        )
    }
    
    public static func reverse(using client: APIClient, id: String, callback: @escaping ReverseRequest.Callback) -> ReverseRequest? {
        let endpoint = reverseEndpointWithID(id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    public static func listScheduleEndpointWithParams(_ params: ListParams?) -> ScheduleListEndpoint {
        return ScheduleListEndpoint(
            method: "GET",
            pathComponents: [ Charge.resourceInfo.path, Schedule<Charge>.resourceInfo.path ],
            params: params
        )
    }
    
    @discardableResult
    public static func listSchedule(using client: APIClient, params: ListParams? = nil, callback: ScheduleListRequest.Callback?) -> ScheduleListRequest? {
        let endpoint = self.listScheduleEndpointWithParams(params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}


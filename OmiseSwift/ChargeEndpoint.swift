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
            pathComponents: [resourceInfo.path, id, "capture"],
            parameter: .post(nil)
        )
    }
    
    public static func capture(using client: APIClient, id: String, callback: @escaping CaptureRequest.Callback) -> CaptureRequest? {
        let endpoint = captureEndpointWithID(id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    public static func reverseEndpointWithID(_ id: String) -> ReverseEndpoint {
        return ReverseEndpoint(
            pathComponents: [resourceInfo.path, id, "reverse"],
            parameter: .post(nil)
        )
    }
    
    public static func reverse(using client: APIClient, id: String, callback: @escaping ReverseRequest.Callback) -> ReverseRequest? {
        let endpoint = reverseEndpointWithID(id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    public static func listScheduleEndpointWithParams(_ params: ListParams?) -> ScheduleListEndpoint {
        return Schedule<Charge>.listDataScheduleEndpointWithParams(params)
    }
    
    @discardableResult
    public static func listSchedule(using client: APIClient, params: ListParams? = nil, callback: ScheduleListRequest.Callback?) -> ScheduleListRequest? {
        return Schedule<Charge>.listDataSchedule(using: client, params: params, callback: callback)
    }
    
    @discardableResult
    public static func listSchedule(using client: APIClient, listParams: ListParams? = nil, callback: @escaping (APIResult<List<Schedule<Charge>>>) -> Void) -> ScheduleListRequest? {
        return Schedule<Charge>.listDataSchedule(using: client, listParams: listParams, callback: callback)
    }
}


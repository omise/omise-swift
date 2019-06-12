import Foundation


extension Charge {
    public typealias ChargeOperationEndpoint = APIEndpoint<Charge>
    public typealias ChargeOperationRequest = APIRequest<Charge>
    
    public typealias CaptureEndpoint = ChargeOperationEndpoint
    public typealias CaptureRequest = ChargeOperationRequest
    public typealias ReverseEndpoint = ChargeOperationEndpoint
    public typealias ReverseRequest = ChargeOperationRequest
    
    public typealias MarkChargeEndpoint = ChargeOperationEndpoint
    public typealias MarkChargeRequest = ChargeOperationRequest
    
    
    public typealias ScheduleListEndpoint = APIEndpoint<ListProperty<Schedule<Charge>>>
    public typealias ScheduleListRequest = APIRequest<ListProperty<Schedule<Charge>>>
    
    public static func captureEndpointWithID(_ id: DataID<Charge>) -> CaptureEndpoint {
        return CaptureEndpoint(
            pathComponents: [resourcePath, id.idString, "capture"],
            parameter: .post(nil)
        )
    }
    
    public static func capture(using client: APIClient, id: DataID<Charge>, callback: @escaping CaptureRequest.Callback) -> CaptureRequest? {
        let endpoint = captureEndpointWithID(id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    public static func reverseEndpointWithID(_ id: DataID<Charge>) -> ReverseEndpoint {
        return ReverseEndpoint(
            pathComponents: [resourcePath, id.idString, "reverse"],
            parameter: .post(nil)
        )
    }
    
    public static func reverse(using client: APIClient, id: DataID<Charge>, callback: @escaping ReverseRequest.Callback) -> ReverseRequest? {
        let endpoint = reverseEndpointWithID(id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    public static func expireEndpointWithID(_ id: DataID<Charge>) -> ReverseEndpoint {
        return ReverseEndpoint(
            pathComponents: [resourcePath, id.idString, "expire"],
            parameter: .post(nil)
        )
    }
    
    public static func expire(using client: APIClient, id: DataID<Charge>, callback: @escaping ReverseRequest.Callback) -> ReverseRequest? {
        let endpoint = expireEndpointWithID(id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    public static func markAsPaidEndpointWithID(_ id: DataID<Charge>) -> ReverseEndpoint {
        precondition(!id.isLiveMode, "Marking Charge API is available only on the test charge")
        
        return ReverseEndpoint(
            pathComponents: [resourcePath, id.idString, "mark_as_paid"],
            parameter: .post(nil)
        )
    }
    
    public static func markAsPaid(using client: APIClient, id: DataID<Charge>, callback: @escaping ReverseRequest.Callback) -> ReverseRequest? {
        let endpoint = markAsPaidEndpointWithID(id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    public static func markAsFailedEndpointWithID(_ id: DataID<Charge>) -> ReverseEndpoint {
        precondition(!id.isLiveMode, "Marking Charge API is available only on the test charge")
        
        return ReverseEndpoint(
            pathComponents: [resourcePath, id.idString, "mark_as_failed"],
            parameter: .post(nil)
        )
    }
    
    public static func markAsFailed(using client: APIClient, id: DataID<Charge>, callback: @escaping ReverseRequest.Callback) -> ReverseRequest? {
        let endpoint = markAsFailedEndpointWithID(id)
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


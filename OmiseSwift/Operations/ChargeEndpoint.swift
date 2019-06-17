import Foundation


extension Charge {
    public typealias ChargeOperationEndpoint = APIEndpoint<NoAPIQuery, Charge>
    public typealias ChargeOperationRequest = APIRequest<NoAPIQuery, Charge>
    
    public typealias CaptureEndpoint = ChargeOperationEndpoint
    public typealias CaptureRequest = ChargeOperationRequest
    public typealias ReverseEndpoint = ChargeOperationEndpoint
    public typealias ReverseRequest = ChargeOperationRequest
    
    public typealias MarkChargeEndpoint = ChargeOperationEndpoint
    public typealias MarkChargeRequest = ChargeOperationRequest
    
    
    public typealias ScheduleListEndpoint = ListAPIEndpoint<Schedule<Charge>>
    public typealias ScheduleListRequest = ListAPIRequest<Schedule<Charge>>
    
    public static func captureEndpoint(with id: DataID<Charge>) -> CaptureEndpoint {
        return CaptureEndpoint(
            pathComponents: [resourcePath, id.idString, "capture"],
            method: .post, query: nil)
    }
    
    public static func capture(using client: APIClient, id: DataID<Charge>, callback: @escaping CaptureRequest.Callback) -> CaptureRequest? {
        let endpoint = captureEndpoint(with: id)
        return client.request(to: endpoint, callback: callback)
    }
    
    public static func reverseEndpoint(with id: DataID<Charge>) -> ReverseEndpoint {
        return ReverseEndpoint(
            pathComponents: [resourcePath, id.idString, "reverse"],
            method: .post, query: nil)
    }
    
    public static func reverse(using client: APIClient, id: DataID<Charge>, callback: @escaping ReverseRequest.Callback) -> ReverseRequest? {
        let endpoint = reverseEndpoint(with: id)
        return client.request(to: endpoint, callback: callback)
    }
    
    public static func expireEndpoint(with id: DataID<Charge>) -> ReverseEndpoint {
        return ReverseEndpoint(
            pathComponents: [resourcePath, id.idString, "expire"],
            method: .post, query: nil)
    }
    
    public static func expire(using client: APIClient, id: DataID<Charge>, callback: @escaping ReverseRequest.Callback) -> ReverseRequest? {
        let endpoint = expireEndpoint(with: id)
        return client.request(to: endpoint, callback: callback)
    }
    
    public static func markAsPaidEndpoint(with id: DataID<Charge>) -> ReverseEndpoint {
        precondition(!id.isLiveMode, "Marking Charge API is available only on the test charge")
        
        return ReverseEndpoint(
            pathComponents: [resourcePath, id.idString, "mark_as_paid"],
            method: .post, query: nil)
    }
    
    public static func markAsPaid(using client: APIClient, id: DataID<Charge>, callback: @escaping ReverseRequest.Callback) -> ReverseRequest? {
        let endpoint = markAsPaidEndpoint(with: id)
        return client.request(to: endpoint, callback: callback)
    }
    
    public static func markAsFailedEndpoint(with id: DataID<Charge>) -> ReverseEndpoint {
        precondition(!id.isLiveMode, "Marking Charge API is available only on the test charge")
        
        return ReverseEndpoint(
            pathComponents: [resourcePath, id.idString, "mark_as_failed"],
            method: .post, query: nil)
    }
    
    public static func markAsFailed(using client: APIClient, id: DataID<Charge>, callback: @escaping ReverseRequest.Callback) -> ReverseRequest? {
        let endpoint = markAsFailedEndpoint(with: id)
        return client.request(to: endpoint, callback: callback)
    }
    
    public static func listScheduleEndpoint(with params: ListParams?) -> ScheduleListEndpoint {
        return Schedule<Charge>.listDataScheduleEndpoint(with: params)
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


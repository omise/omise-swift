import Foundation


extension Transfer {
    public typealias MarkEndpoint = MarkRequest.Endpoint
    public typealias MarkRequest = APIRequest<Transfer>
    
    public typealias ScheduleListEndpoint = APIEndpoint<ListProperty<Schedule<Transfer>>>
    public typealias ScheduleListRequest = APIRequest<ListProperty<Schedule<Transfer>>>
    
    public static func markAsSentEndpointWithID(_ id: String) -> MarkEndpoint {
        return MarkEndpoint(
            pathComponents: [resourcePath, id, "mark_as_sent"],
            parameter: .post(nil)
        )
    }
    
    public static func markAsSent(
        using client: APIClient, id: String, callback: @escaping MarkRequest.Callback
        ) -> MarkRequest? {
        let endpoint = markAsSentEndpointWithID(id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    public static func markAsPaidEndpointWithID(_ id: String) -> MarkEndpoint {
        return MarkEndpoint(
            pathComponents: [resourcePath, id, "mark_as_paid"],
            parameter: .post(nil)
        )
    }
    
    public static func markAsPaid(
        using client: APIClient, id: String, callback: @escaping MarkRequest.Callback
        ) -> MarkRequest? {
        let endpoint = markAsPaidEndpointWithID(id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    
    public static func listScheduleEndpointWithParams(_ params: ListParams?) -> ScheduleListEndpoint {
        return Schedule<Transfer>.listDataScheduleEndpointWithParams(params)
    }
    
    @discardableResult
    public static func listSchedule(
        using client: APIClient, params: ListParams? = nil,
        callback: ScheduleListRequest.Callback?
        ) -> ScheduleListRequest? {
        return Schedule<Transfer>.listDataSchedule(using: client, params: params, callback: callback)
    }
    
    @discardableResult
    public static func listSchedule(
        using client: APIClient, listParams: ListParams? = nil,
        callback: @escaping (APIResult<List<Schedule<Transfer>>>) -> Void
        ) -> ScheduleListRequest? {
        return Schedule<Transfer>.listDataSchedule(using: client, listParams: listParams, callback: callback)
    }
}


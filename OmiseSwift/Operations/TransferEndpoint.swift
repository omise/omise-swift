import Foundation


extension Transfer {
    public typealias MarkEndpoint = MarkRequest.Endpoint
    public typealias MarkRequest = APIRequest<Transfer>
    
    public typealias ScheduleListEndpoint = APIEndpoint<ListProperty<Schedule<Transfer>>>
    public typealias ScheduleListRequest = APIRequest<ListProperty<Schedule<Transfer>>>
    
    public static func markAsSentEndpoint(with id : DataID<Transfer>) -> MarkEndpoint {
        return MarkEndpoint(
            pathComponents: [resourcePath, id.idString, "mark_as_sent"],
            parameter: .post(nil))
    }
    
    public static func markAsSent(
        using client: APIClient, id: DataID<Transfer>, callback: @escaping MarkRequest.Callback
        ) -> MarkRequest? {
        let endpoint = markAsSentEndpoint(with: id)
        return client.request(to: endpoint, callback: callback)
    }
    
    public static func markAsPaidEndpoint(with id : DataID<Transfer>) -> MarkEndpoint {
        return MarkEndpoint(
            pathComponents: [resourcePath, id.idString, "mark_as_paid"],
            parameter: .post(nil))
    }
    
    public static func markAsPaid(
        using client: APIClient, id: DataID<Transfer>, callback: @escaping MarkRequest.Callback
        ) -> MarkRequest? {
        let endpoint = markAsPaidEndpoint(with: id)
        return client.request(to: endpoint, callback: callback)
    }
    
    
    public static func listScheduleEndpoint(with params: ListParams?) -> ScheduleListEndpoint {
        return Schedule<Transfer>.listDataScheduleEndpoint(with: params)
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


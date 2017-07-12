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
        return ScheduleListEndpoint(
            pathComponents: [ Charge.resourceInfo.path, Schedule<Charge>.resourceInfo.path ],
            parameter: .get(nil)
        )
    }
    
    @discardableResult
    public static func listSchedule(using client: APIClient, params: ListParams? = nil, callback: ScheduleListRequest.Callback?) -> ScheduleListRequest? {
        let endpoint = self.listScheduleEndpointWithParams(params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    @discardableResult
    public static func listSchedule(using client: APIClient, listParams: ListParams? = nil, callback: @escaping (Failable<List<Schedule<Charge>>>) -> Void) -> ScheduleListRequest? {
        let endpoint = self.listScheduleEndpointWithParams(listParams)
        
        let requestCallback: ScheduleListRequest.Callback = { result in
            let callbackResult = result.map({
                List(endpoint: endpoint.endpoint, paths: endpoint.pathComponents, order: listParams?.order, list: $0)
            })
            callback(callbackResult)
        }
        
        return client.requestToEndpoint(endpoint, callback: requestCallback)
    }
}


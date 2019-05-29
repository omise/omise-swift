import Foundation

extension Schedule where Data: OmiseLocatableObject {
    public typealias ScheduleListEndpoint = APIEndpoint<ListProperty<Schedule<Data>>>
    public typealias ScheduleListRequest = APIRequest<ListProperty<Schedule<Data>>>
    
    
    public static func listDataScheduleEndpointWithParams(_ params: ListParams?) -> ScheduleListEndpoint {
        return ScheduleListEndpoint(
            pathComponents: [ Data.resourcePath, Schedule<Data>.resourcePath ],
            parameter: .get(nil)
        )
    }
    
    @discardableResult
    public static func listDataSchedule(using client: APIClient, params: ListParams? = nil, callback: ScheduleListRequest.Callback?) -> ScheduleListRequest? {
        let endpoint = self.listDataScheduleEndpointWithParams(params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    @discardableResult
    public static func listDataSchedule(using client: APIClient, listParams: ListParams? = nil, callback: @escaping (APIResult<List<Schedule<Data>>>) -> Void) -> ScheduleListRequest? {
        let endpoint = self.listDataScheduleEndpointWithParams(listParams)
        
        let requestCallback: ScheduleListRequest.Callback = { result in
            let callbackResult = result.map({
                List(endpoint: endpoint.endpoint, paths: endpoint.pathComponents, order: listParams?.order, list: $0)
            })
            callback(callbackResult)
        }
        
        return client.requestToEndpoint(endpoint, callback: requestCallback)
    }
    
}


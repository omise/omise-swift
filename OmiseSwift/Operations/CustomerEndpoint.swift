import Foundation

extension Customer {
    public typealias ScheduleListEndpoint = APIEndpoint<ListProperty<Schedule<Charge>>>
    public typealias ScheduleListRequest = APIRequest<ListProperty<Schedule<Charge>>>
    
    public static func listScheduleEndpointChargingCustomer(with customerID: DataID<Customer>, params: ListParams?) -> ScheduleListEndpoint {
        return ScheduleListEndpoint(
            pathComponents: [ Customer.resourcePath, customerID.idString, Schedule<Charge>.resourcePath ],
            parameter: .get(params))
    }
    
    @discardableResult
    public static func listScheduleChargingCustomer(using client: APIClient, customerID: DataID<Customer>, params: ListParams? = nil, callback: ScheduleListRequest.Callback?) -> ScheduleListRequest? {
        let endpoint = self.listScheduleEndpointChargingCustomer(with: customerID, params: params)
        return client.request(to: endpoint, callback: callback)
    }
    
    @discardableResult
    public static func listScheduleChargingCustomer(using client: APIClient, customerID: DataID<Customer>, listParams: ListParams? = nil, callback: @escaping (APIResult<List<Schedule<Charge>>>) -> Void) -> ScheduleListRequest? {
        let endpoint = self.listScheduleEndpointChargingCustomer(with: customerID, params: listParams)
        
        let requestCallback: ScheduleListRequest.Callback = { result in
            let callbackResult = result.map({
                List(listEndpoint: endpoint, list: $0)
            })
            callback(callbackResult)
        }
        
        return client.request(to: endpoint, callback: requestCallback)
    }
}



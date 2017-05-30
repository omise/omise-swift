import Foundation

extension Customer {
    public typealias ScheduleListEndpoint = APIEndpoint<ListProperty<Schedule<Charge>>>
    public typealias ScheduleListRequest = APIRequest<ListProperty<Schedule<Charge>>>
    
    public static func listScheduleEndpointChargingCustomerWith(customerID: String, params: ListParams?) -> ScheduleListEndpoint {
        return ScheduleListEndpoint(
            method: "GET",
            pathComponents: [ Customer.resourceInfo.path, customerID, Schedule<Charge>.resourceInfo.path ],
            params: params
        )
    }
    
    @discardableResult
    public static func listScheduleChargingCustomer(using client: APIClient, customerID: String, params: ListParams? = nil, callback: ScheduleListRequest.Callback?) -> ScheduleListRequest? {
        let endpoint = self.listScheduleEndpointChargingCustomerWith(customerID: customerID, params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    @discardableResult
    public static func listScheduleChargingCustomer(using client: APIClient, customerID: String, listParams: ListParams? = nil, callback: @escaping (Failable<List<Schedule<Charge>>>) -> Void) -> ScheduleListRequest? {
        let endpoint = self.listScheduleEndpointChargingCustomerWith(customerID: customerID, params: listParams)
        
        let requestCallback: ScheduleListRequest.Callback = { result in
            let callbackResult = result.map({
                List(endpoint: endpoint.endpoint, paths: endpoint.pathComponents, order: listParams?.order, list: $0)
            })
            callback(callbackResult)
        }
        
        return client.requestToEndpoint(endpoint, callback: requestCallback)
    }
}



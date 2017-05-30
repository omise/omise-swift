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
}



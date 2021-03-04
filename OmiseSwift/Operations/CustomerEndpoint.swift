import Foundation


extension Customer {
    public typealias ScheduleListEndpoint = ListAPIEndpoint<Schedule<Charge>>
    public typealias ScheduleListRequest = ListAPIRequest<Schedule<Charge>>
    
    public static func listChargingCustomerScheduleEndpoint(
        for customerID: DataID<Customer>,
        params: ListParams?
    ) -> ScheduleListEndpoint {
        return ScheduleListEndpoint(
            pathComponents: [ Customer.resourcePath, customerID.idString, Schedule<Charge>.resourcePath ],
            method: .get,
            query: params)
    }
    
    @discardableResult
    public static func listChargingCustomerSchedule(
        using client: APIClient,
        customerID: DataID<Customer>,
        params: ListParams? = nil,
        callback: ScheduleListRequest.Callback?
    ) -> ScheduleListRequest? {
        let endpoint = self.listChargingCustomerScheduleEndpoint(for: customerID, params: params)
        return client.request(to: endpoint, callback: callback)
    }
    
    @discardableResult
    public static func listChargingCustomerSchedule(
        using client: APIClient,
        customerID: DataID<Customer>,
        listParams: ListParams? = nil,
        callback: @escaping (APIResult<List<Schedule<Charge>>>) -> Void
    ) -> ScheduleListRequest? {
        let endpoint = self.listChargingCustomerScheduleEndpoint(for: customerID, params: listParams)
        
        let requestCallback: ScheduleListRequest.Callback = { result in
            let callbackResult = result.map {
                List(listEndpoint: endpoint, list: $0)
            }
            callback(callbackResult)
        }
        
        return client.request(to: endpoint, callback: requestCallback)
    }
}

import Foundation

extension Recipient {
    public typealias ScheduleListEndpoint = APIEndpoint<ListProperty<Schedule<Transfer>>>
    public typealias ScheduleListRequest = APIRequest<ListProperty<Schedule<Transfer>>>
    
    public static func listScheduleEndpointTransferingRecipientWith(
        recipientID: DataID<Recipient>, params: ListParams?) -> ScheduleListEndpoint {
        return ScheduleListEndpoint(
            pathComponents: [ Recipient.resourcePath, recipientID.idString, Schedule<Transfer>.resourcePath ],
            parameter: .get(params)
        )
    }
    
    @discardableResult
    public static func listScheduleTransferingRecipient(
        using client: APIClient, recipientID: DataID<Recipient>,
        params: ListParams? = nil, callback: ScheduleListRequest.Callback?
        ) -> ScheduleListRequest? {
        let endpoint = self.listScheduleEndpointTransferingRecipientWith(recipientID: recipientID, params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    @discardableResult
    public static func listScheduleTransferingRecipient(
        using client: APIClient, recipientID: DataID<Recipient>,
        listParams: ListParams? = nil, callback: @escaping (APIResult<List<Schedule<Transfer>>>) -> Void
        ) -> ScheduleListRequest? {
        let endpoint = self.listScheduleEndpointTransferingRecipientWith(recipientID: recipientID, params: listParams)
        
        let requestCallback: ScheduleListRequest.Callback = { result in
            let callbackResult = result.map({
                List(endpoint: endpoint.endpoint, paths: endpoint.pathComponents, order: listParams?.order, list: $0)
            })
            callback(callbackResult)
        }
        
        return client.requestToEndpoint(endpoint, callback: requestCallback)
    }
}



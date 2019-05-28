import Foundation


public extension Refund {
    typealias ListEndpoint = APIEndpoint<ListProperty<Refund>>
    typealias ListRequest = APIRequest<ListProperty<Refund>>
    
    @discardableResult
    static func listEndpointWith(params: ListParams?) -> ListEndpoint {
        return ListEndpoint(
            pathComponents: [Refund.resourceInfo.path],
            parameter: .get(params)
        )
    }
    
    @discardableResult
    static func list(using client: APIClient, params: ListParams? = nil, callback: ListRequest.Callback?) -> ListRequest? {
        let endpoint = self.listEndpointWith(params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
    @discardableResult
    static func list(using client: APIClient, listParams: ListParams? = nil, callback: @escaping (APIResult<List<Refund>>) -> Void) -> ListRequest? {
        let endpoint = self.listEndpointWith(params: listParams)
        
        let requestCallback: ListRequest.Callback = { result in
            let callbackResult = result.map({
                List(endpoint: endpoint.endpoint, paths: endpoint.pathComponents, order: listParams?.order, list: $0)
            })
            callback(callbackResult)
        }
        
        return client.requestToEndpoint(endpoint, callback: requestCallback)
    }
}

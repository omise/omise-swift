import Foundation


public extension Refund {
    typealias ListEndpoint = APIEndpoint<ListProperty<Refund>>
    typealias ListRequest = APIRequest<ListProperty<Refund>>
    
    @discardableResult
    static func listEndpoint(with params: ListParams?) -> ListEndpoint {
        return ListEndpoint(
            pathComponents: [Refund.resourcePath],
            parameter: .get(params))
    }
    
    @discardableResult
    static func list(using client: APIClient, params: ListParams? = nil, callback: ListRequest.Callback?) -> ListRequest? {
        let endpoint = self.listEndpoint(with: params)
        return client.request(to: endpoint, callback: callback)
    }
    
    @discardableResult
    static func list(using client: APIClient, listParams: ListParams? = nil, callback: @escaping (APIResult<List<Refund>>) -> Void) -> ListRequest? {
        let endpoint = self.listEndpoint(with: listParams)
        
        let requestCallback: ListRequest.Callback = { result in
            let callbackResult = result.map({
                List(listEndpoint: endpoint, list: $0)
            })
            callback(callbackResult)
        }
        
        return client.request(to: endpoint, callback: requestCallback)
    }
}

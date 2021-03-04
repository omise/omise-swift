import Foundation


extension Forex {
    public typealias RetrieveEndpoint = APIEndpoint<NoAPIQuery, Forex>
    public typealias RetrieveRequest = APIRequest<NoAPIQuery, Forex>
    
    public static func retrieveEndpoint(exchangeFrom currency: Currency) -> Forex.RetrieveEndpoint {
        return Forex.RetrieveEndpoint(
            pathComponents: [resourcePath, currency.code ],
            method: .get,
            query: nil)
    }
    
    public static func retrieve(
        using client: APIClient,
        exchangeFrom currency: Currency,
        callback: @escaping RetrieveRequest.Callback
    ) -> RetrieveRequest? {
        let endpoint = retrieveEndpoint(exchangeFrom: currency)
        return client.request(to: endpoint, callback: callback)
    }
}

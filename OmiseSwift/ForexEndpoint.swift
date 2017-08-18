import Foundation


extension Forex {
    public typealias RetrieveEndpoint = APIEndpoint<Forex>
    public typealias RetrieveRequest = APIRequest<Forex>

    public static func retrieveEndpoint(exchangeFrom currency: Currency) -> Forex.RetrieveEndpoint {
        return Forex.RetrieveEndpoint(
            pathComponents: [resourceInfo.path, currency.code ],
            parameter: .get(nil)
        )
    }
    
    public static func retrieve(using client: APIClient, exchangeFrom currency: Currency, callback: @escaping RetrieveRequest.Callback) -> RetrieveRequest? {
        let endpoint = retrieveEndpoint(exchangeFrom: currency)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}


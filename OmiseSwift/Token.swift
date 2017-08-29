import Foundation

public struct Token: OmiseResourceObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/tokens")
    
    public var object: String
    public var location: String
    
    public var id: String
    public var createdDate: Date
    public var isLive: Bool
    
    public var isUsed: Bool
    
    public var card: Card
}


public struct TokenParams: APIJSONQuery {
    public var name: String?
    
    public var number: String
    
    public var expiration: (month: Int, year: Int)?
    
    public var securityCode: String?
    
    public var city: String?
    
    public var postalCode: String?
    
    private enum TokenCodingKeys: String, CodingKey {
        case card
        
        enum CardCodingKeys: String, CodingKey {
            case number
            case name
            case expirationMonth = "expiration_month"
            case expirationYear = "expiration_year"
            case securityCode = "security_code"
            case city
            case postalCode = "postal_code"
        }
    }

    
    public func encode(to encoder: Encoder) throws {
        var tokenContainer = encoder.container(keyedBy: TokenCodingKeys.self)
        var cardContainer = tokenContainer.nestedContainer(keyedBy: TokenCodingKeys.CardCodingKeys.self, forKey: .card)
        
        try cardContainer.encode(number, forKey: .number)
        try cardContainer.encodeIfPresent(name, forKey: .name)
        try cardContainer.encodeIfPresent(expiration?.month, forKey: .expirationMonth)
        try cardContainer.encodeIfPresent(expiration?.year, forKey: .expirationYear)
        try cardContainer.encodeIfPresent(securityCode, forKey: .securityCode)
        try cardContainer.encodeIfPresent(city, forKey: .city)
        try cardContainer.encodeIfPresent(postalCode, forKey: .postalCode)
    }
    
    public init(number: String, name: String?, expiration: (month: Int, year: Int)?, securityCode: String?, city: String? = nil, postalCode: String? = nil) {
        self.number = number
        self.name = name
        self.expiration = expiration
        self.securityCode = securityCode
        self.city = city
        self.postalCode = postalCode
    }
}

extension Token: Creatable {
    public typealias CreateParams = TokenParams
    
    public static func createEndpointWith(parent: OmiseResourceObject?, usingKey key: AccessKey, params: CreateParams) -> CreateEndpoint {
        return CreateEndpoint(
            endpoint: .vault(key),
            pathComponents: Token.makeResourcePathsWithParent(parent),
            parameter: .post(params)
        )
    }
    
    public static func create(using client: APIClient, parent: OmiseResourceObject? = nil, usingKey key: AccessKey, params: CreateParams, callback: @escaping CreateRequest.Callback) -> CreateRequest? {
        guard Token.verifyParent(parent) else {
            return nil
        }
        
        let endpoint = self.createEndpointWith(parent: parent, usingKey: key, params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
    
}

extension Token: Retrievable {
    public typealias RetrieveEndpoint = APIEndpoint<Token>
    public typealias RetrieveRequest = APIRequest<Token>
    
    public static func retrieveEndpointWith(parent: OmiseResourceObject?, id: String) -> RetrieveEndpoint {
        return RetrieveEndpoint(
            endpoint: .api,
            pathComponents: [resourceInfo.path, id],
            parameter: .get(nil)
        )
    }
    
    public static func retrieve(using client: APIClient, parent: OmiseResourceObject? = nil, id: String, callback: @escaping RetrieveRequest.Callback) -> RetrieveRequest? {
        guard verifyParent(parent) else {
            return nil
        }
        
        let endpoint = self.retrieveEndpointWith(parent: parent, id: id)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

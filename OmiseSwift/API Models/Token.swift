import Foundation


public struct Token: OmiseResourceObject, Equatable {
    public static let resourcePath = "/tokens"
    public static let idPrefix: String = "tokn"
    
    public var object: String
    public var location: String
    
    public let id: DataID<Token>
    public let createdDate: Date
    public var isLiveMode: Bool
    
    public var isUsed: Bool
    
    public var card: Card
}

extension Token {
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case createdDate = "created_at"
        case isLiveMode = "livemode"
        case isUsed = "used"
        case card
    }
}


public struct TokenParams: APIJSONQuery {
    public var name: String
    
    public var number: String
    
    public var expiration: (month: Int, year: Int)
    
    public var securityCode: String?
    
    public var billingAddress: BillingAddress?
    
    private enum TokenCodingKeys: String, CodingKey {
        case card
        
        enum CardCodingKeys: String, CodingKey {
            case number
            case name
            case expirationMonth = "expiration_month"
            case expirationYear = "expiration_year"
            case securityCode = "security_code"
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var tokenContainer = encoder.container(keyedBy: TokenCodingKeys.self)
        
        var cardContainer = tokenContainer.nestedContainer(
            keyedBy: CombineCodingKeys<TokenCodingKeys.CardCodingKeys, BillingAddress.CodingKeys>.self, forKey: .card)
        try cardContainer.encode(number, forKey: .left(.number))
        try cardContainer.encode(name, forKey: .left(.name))
        try cardContainer.encode(expiration.month, forKey: .left(.expirationMonth))
        try cardContainer.encode(expiration.year, forKey: .left(.expirationYear))
        try cardContainer.encodeIfPresent(securityCode, forKey: .left(.securityCode))
        
        try cardContainer.encodeIfPresent(billingAddress?.street1, forKey: .right(.street1))
        try cardContainer.encodeIfPresent(billingAddress?.street2, forKey: .right(.street2))
        try cardContainer.encodeIfPresent(billingAddress?.city, forKey: .right(.city))
        try cardContainer.encodeIfPresent(billingAddress?.state, forKey: .right(.state))
        try cardContainer.encodeIfPresent(billingAddress?.postalCode, forKey: .right(.postalCode))
        try cardContainer.encodeIfPresent(billingAddress?.countryCode, forKey: .right(.countryCode))
        try cardContainer.encodeIfPresent(billingAddress?.phoneNumber, forKey: .right(.phoneNumber))
    }
    
    public init(
        number: String,
        name: String,
        expiration: (month: Int, year: Int),
        securityCode: String?,
        billingAddress: BillingAddress? = nil
    ) {
        self.number = number
        self.name = name
        self.expiration = expiration
        self.securityCode = securityCode
        self.billingAddress = billingAddress
    }
}


extension Token {}

extension Token: Retrievable {
    public typealias RetrieveEndpoint = APIEndpoint<RetrieveParams, Token>
    public typealias RetrieveRequest = APIRequest<RetrieveParams, Token>
    
    static func retrieveEndpoint(usingKey key: AccessKey, id: String) -> RetrieveEndpoint {
        let retrieveParams = RetrieveParams(isExpanded: true)
        return RetrieveEndpoint(
            endpoint: .vault(key),
            pathComponents: [Token.resourcePath, id],
            method: .get, query: retrieveParams)
    }
    
    static func retrieve(
        using client: APIClient,
        usingKey key: AccessKey,
        id: String,
        callback: @escaping RetrieveRequest.Callback
    ) -> RetrieveRequest? {
        let endpoint = self.retrieveEndpoint(usingKey: key, id: id)
        return client.request(to: endpoint, callback: callback)
    }
}

extension Token: Creatable {
    public typealias CreateParams = TokenParams
    
    public static func createEndpoint(usingKey key: AccessKey, params: CreateParams) -> CreateEndpoint {
        return CreateEndpoint(
            endpoint: .vault(key),
            pathComponents: [Token.resourcePath],
            method: .post, query: params)
    }
    
    public static func create(
        using client: APIClient,
        usingKey key: AccessKey,
        params: CreateParams,
        callback: @escaping CreateRequest.Callback
    ) -> CreateRequest? {
        let endpoint = self.createEndpoint(usingKey: key, params: params)
        return client.request(to: endpoint, callback: callback)
    }
    
}

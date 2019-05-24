import Foundation


public struct Token: OmiseResourceObject, Equatable {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/tokens")
    
    public var object: String
    public var location: String
    
    public var id: String
    public var createdDate: Date
    public var isLiveMode: Bool
    
    public var isUsed: Bool
    
    public var card: Card
    
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
    public var name: String?
    
    public var number: String
    
    public var expiration: (month: Int, year: Int)?
    
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
        
        var cardContainer = tokenContainer.nestedContainer(keyedBy: CombineCodingKeys<TokenCodingKeys.CardCodingKeys, BillingAddress.CodingKeys>.self, forKey: .card)
        try cardContainer.encode(number, forKey: .left(.number))
        try cardContainer.encodeIfPresent(name, forKey: .left(.name))
        try cardContainer.encodeIfPresent(expiration?.month, forKey: .left(.expirationMonth))
        try cardContainer.encodeIfPresent(expiration?.year, forKey: .left(.expirationYear))
        try cardContainer.encodeIfPresent(securityCode, forKey: .left(.securityCode))
        
        try cardContainer.encodeIfPresent(billingAddress?.street1, forKey: .right(.street1))
        try cardContainer.encodeIfPresent(billingAddress?.street2, forKey: .right(.street2))
        try cardContainer.encodeIfPresent(billingAddress?.city, forKey: .right(.city))
        try cardContainer.encodeIfPresent(billingAddress?.state, forKey: .right(.state))
        try cardContainer.encodeIfPresent(billingAddress?.postalCode, forKey: .right(.postalCode))
        try cardContainer.encodeIfPresent(billingAddress?.countryCode, forKey: .right(.countryCode))
        try cardContainer.encodeIfPresent(billingAddress?.phoneNumber, forKey: .right(.phoneNumber))
    }
    
    public init(number: String, name: String?,
        expiration: (month: Int, year: Int)?, securityCode: String?,
        billingAddress: BillingAddress? = nil) {
        self.number = number
        self.name = name
        self.expiration = expiration
        self.securityCode = securityCode
        self.billingAddress = billingAddress
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


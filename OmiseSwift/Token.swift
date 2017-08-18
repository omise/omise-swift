import Foundation

public struct Token: OmiseLocatableObject, OmiseIdentifiableObject, OmiseLiveModeObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/tokens")
    
    public var object: String
    public var location: String
    
    public var id: String
    public var createdDate: Date
    public var isLive: Bool
    
    public var isUsed: Bool
    
    public var card: Card
}

extension Token {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties: (String, String, String, Date) = Token.parseOmiseProperties(JSON: json),
            let isLive = json["livemode"] as? Bool else {
                return nil
        }
        
        guard let isUsed = json["used"] as? Bool,
            let card = json["card"].flatMap(Card.init(JSON:)) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.createdDate) = omiseObjectProperties
        self.isLive = isLive
        self.isUsed = isUsed
        self.card = card
    }
}

public struct TokenParams: APIJSONQuery {
    public var name: String?
    
    public var number: String
    
    public var expiration: (month: Int, year: Int)?
    
    public var securityCode: String?
    
    public var city: String?
    
    public var postalCode: String?
    
    public var json: JSONAttributes {
        return [
            "card": Dictionary.makeFlattenDictionaryFrom([
                "name": name,
                "number": number,
                "expiration_month": expiration?.month,
                "expiration_year": expiration?.year,
                "security_code": securityCode,
                "city": city as Any,
                "postal_code": postalCode,
                ])
        ]
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
    
    public static func createEndpointWith(parent: OmiseResourceObject?, usingKey key: Key<PublicKey>, params: CreateParams) -> CreateEndpoint {
        return CreateEndpoint(
            endpoint: .vault(key),
            pathComponents: Token.makeResourcePathsWithParent(parent),
            parameter: .post(params)
        )
    }
    
    public static func create(using client: APIClient, parent: OmiseResourceObject? = nil, usingKey key: Key<PublicKey>, params: CreateParams, callback: @escaping CreateRequest.Callback) -> CreateRequest? {
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

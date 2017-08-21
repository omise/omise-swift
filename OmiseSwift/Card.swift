import Foundation

public enum CardBrand: String {
    case visa = "Visa"
    case masterCard = "MasterCard"
    case jcb = "JCB"
    case amex = "American Express"
    case diners = "Diners Club"
    case discover = "Discover"
    case maestro = "Maestro"
}


public enum CardFinancing: String {
    case credit
    case debit
}


public enum Card: OmiseIdentifiableObject, OmiseLiveModeObject {
    case tokenized(TokenizedCard)
    case customer(CustomerCard)
    
    
    public var object: String {
        switch self {
        case .tokenized(let card):
            return card.object
        case .customer(let card):
            return card.object
        }
    }
    
    public var id: String {
        switch self {
        case .tokenized(let card):
            return card.id
        case .customer(let card):
            return card.id
        }
    }
    
    public var isLive: Bool {
        switch self {
        case .tokenized(let card):
            return card.isLive
        case .customer(let card):
            return card.isLive
        }
    }
    
    public var createdDate: Date {
        switch self {
        case .tokenized(let card):
            return card.createdDate
        case .customer(let card):
            return card.createdDate
        }
    }
    
    public var countryCode: String? {
        switch self {
        case .tokenized(let card):
            return card.countryCode
        case .customer(let card):
            return card.countryCode
        }
    }
    
    public var city: String? {
        switch self {
        case .tokenized(let card):
            return card.city
        case .customer(let card):
            return card.city
        }
    }
    
    public var postalCode: String? {
        switch self {
        case .tokenized(let card):
            return card.postalCode
        case .customer(let card):
            return card.postalCode
        }
    }
    
    public var bankName: String? {
        switch self {
        case .tokenized(let card):
            return card.bankName
        case .customer(let card):
            return card.bankName
        }
    }
    
    public var lastDigits: LastDigits {
        switch self {
        case .tokenized(let card):
            return card.lastDigits
        case .customer(let card):
            return card.lastDigits
        }
    }
    
    public var brand: CardBrand {
        switch self {
        case .tokenized(let card):
            return card.brand
        case .customer(let card):
            return card.brand
        }
    }
    
    public var expiration: (month: Int, year: Int)? {
        switch self {
        case .tokenized(let card):
            return card.expiration
        case .customer(let card):
            return card.expiration
        }
    }
    
    public var name: String? {
        switch self {
        case .tokenized(let card):
            return card.name
        case .customer(let card):
            return card.name
        }
    }
    
    public var fingerPrint: String {
        switch self {
        case .tokenized(let card):
            return card.fingerPrint
        case .customer(let card):
            return card.fingerPrint
        }
    }
    
    public var financing: CardFinancing? {
        switch self {
        case .tokenized(let card):
            return card.financing
        case .customer(let card):
            return card.financing
        }
    }
}

extension Card {
    public init?(JSON json: Any) {
        if let parsedCustomerCard = CustomerCard.init(JSON: json) {
            self = .customer(parsedCustomerCard)
        } else if let parsedTokenizedCard = TokenizedCard(JSON: json) {
            self = .tokenized(parsedTokenizedCard)
        } else {
            return nil
        }
    }
}

public struct TokenizedCard: OmiseIdentifiableObject, OmiseLiveModeObject, OmiseCreatableObject {
    public let object: String
    
    public let id: String
    public let isLive: Bool
    public var createdDate: Date

    public let countryCode: String?
    public let city: String?
    public let postalCode: String?
    
    public let bankName: String?
    
    public let lastDigits: LastDigits
    public let brand: CardBrand
    public let expiration: (month: Int, year: Int)?
    
    public let name: String?
    public let fingerPrint: String
    
    public let financing: CardFinancing?
}

extension TokenizedCard {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any] else {
            return nil
        }
        
        guard let idProperties = TokenizedCard.parseIdentifiableProperties(JSON: json),
            let isLive = json["livemode"] as? Bool,
            let lastDigits = LastDigitsConverter.convert(fromAttribute: json["last_digits"]),
            let cardBrand: CardBrand = EnumConverter.convert(fromAttribute: json["brand"]),
            let fingerPrint = json["fingerprint"] as? String else {
                return nil
        }
        
        (self.object, self.id, self.createdDate) = idProperties
        self.isLive = isLive
        self.lastDigits = lastDigits
        self.brand = cardBrand
        
        self.name = json["name"] as? String
        self.bankName = json["bank"] as? String
        self.postalCode = json["postal_code"] as? String
        self.countryCode = json["country"] as? String
        self.city = json["city"] as? String
        
        self.financing = EnumConverter.convert(fromAttribute: json["financing"])
        self.fingerPrint = fingerPrint
        
        if let expirationMonth = json["expiration_month"] as? Int, let expirationYear = json["expiration_year"] as? Int {
            self.expiration = (month: expirationMonth, year: expirationYear)
        } else {
            self.expiration = nil
        }
    }
}

public struct CustomerCard: OmiseResourceObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(parentType: Customer.self, path: "/cards")
    
    public let location: String
    public let object: String
    
    public let id: String
    public let isLive: Bool
    public var createdDate: Date
    
    public let countryCode: String?
    public let city: String?
    public let postalCode: String?
    
    public let bankName: String?
    
    public let lastDigits: LastDigits
    public let brand: CardBrand
    public let expiration: (month: Int, year: Int)?
    
    public let name: String?
    public let fingerPrint: String
    
    public let financing: CardFinancing?
}


extension CustomerCard {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any] else {
            return nil
        }
        
        guard let omiseObjectProperties = CustomerCard.parseOmiseResource(JSON: json),
            let lastDigits = LastDigitsConverter.convert(fromAttribute: json["last_digits"]),
            let cardBrand: CardBrand = EnumConverter.convert(fromAttribute: json["brand"]),
            let fingerPrint = json["fingerprint"] as? String else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate) = omiseObjectProperties
        self.lastDigits = lastDigits
        self.brand = cardBrand
        
        self.name = json["name"] as? String
        self.bankName = json["bank"] as? String
        self.postalCode = json["postal_code"] as? String
        self.countryCode = json["country"] as? String
        self.city = json["city"] as? String
        
        self.financing = EnumConverter.convert(fromAttribute: json["financing"])
        self.fingerPrint = fingerPrint
        
        if let expirationMonth = json["expiration_month"] as? Int, let expirationYear = json["expiration_year"] as? Int {
            self.expiration = (month: expirationMonth, year: expirationYear)
        } else {
            self.expiration = nil
        }
    }
}

public struct CardParams: APIJSONQuery {
    public var name: String?
    public var expirationMonth: Int?
    public var expirationYear: Int?
    public var postalCode: String?
    public var city: String?

    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "name": name,
            "expiration_month": expirationMonth,
            "expiration_year": expirationYear,
            "postal_code": postalCode,
            "city": city,
        ])
    }
    
    public init(name: String? = nil,
         expirationMonth: Int? = nil, expirationYear: Int? = nil,
         postalCode: String? = nil, city: String? = nil) {
        self.name = name
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.postalCode = postalCode
        self.city = city
    }
}


extension CustomerCard: Listable {}
extension CustomerCard: Retrievable {}
extension CustomerCard: Destroyable {}
extension CustomerCard: Updatable {
    public typealias UpdateParams = CardParams
}


extension Customer {
    public func listCards(using client: APIClient, params: ListParams? = nil, callback: @escaping CustomerCard.ListRequest.Callback) -> CustomerCard.ListRequest? {
        return CustomerCard.list(using: client, parent: self, params: params, callback: callback)
    }
    
    public func retrieveCard(using client: APIClient, id: String, callback: @escaping CustomerCard.RetrieveRequest.Callback) -> CustomerCard.RetrieveRequest? {
        return CustomerCard.retrieve(using: client, parent: self, id: id, callback: callback)
    }
    
    public func updateCard(using client: APIClient, id: String, params: CardParams, callback: @escaping CustomerCard.UpdateRequest.Callback) -> CustomerCard.UpdateRequest? {
        return CustomerCard.update(using: client, parent: self, id: id, params: params, callback: callback)
    }
    
    public func destroyCard(using client: APIClient, id: String, callback: @escaping CustomerCard.DestroyRequest.Callback) -> CustomerCard.DestroyRequest? {
        return CustomerCard.destroy(using: client, parent: self, id: id, callback: callback)
    }
}


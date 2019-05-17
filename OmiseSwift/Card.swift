import Foundation

public enum CardBrand: String, Codable, Equatable {
    case visa = "Visa"
    case masterCard = "MasterCard"
    case jcb = "JCB"
    case amex = "American Express"
    case diners = "Diners Club"
    case discover = "Discover"
    case maestro = "Maestro"
}


public enum CardFinancing: RawRepresentable, Codable, Equatable {
    public var rawValue: String {
        switch self {
        case .credit:
            return "credit"
        case .debit:
            return "debit"
        case .unknown(let value):
            return value
        }
    }
    
    case credit
    case debit
    case unknown(String)
    
    public init?(rawValue: String) {
        switch rawValue {
        case "credit", "":
            self = .credit
        case "debit":
            self = .debit
        case let value:
            self = .unknown(value)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value {
        case "credit", "":
            self = .credit
        case "debit":
            self = .debit
        case let value:
            self = .unknown(value)
        }
    }
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
    
    public var isLiveMode: Bool {
        switch self {
        case .tokenized(let card):
            return card.isLiveMode
        case .customer(let card):
            return card.isLiveMode
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
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = .customer(try container.decode(CustomerCard.self))
        } catch let error where error is DecodingError {
            self = .tokenized(try container.decode(TokenizedCard.self))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .customer(let customerCard):
            try customerCard.encode(to: encoder)
        case .tokenized(let tokenizedCard):
            try tokenizedCard.encode(to: encoder)
        }
    }
}

public struct TokenizedCard: OmiseIdentifiableObject, OmiseLiveModeObject, OmiseCreatableObject {
    public let object: String
    
    public let id: String
    public let isLive: Bool
    public var createdDate: Date
    public let isDeleted: Bool

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
    
    public let passSecurityCodeCheck: Bool
}

extension TokenizedCard {
    private enum CodingKeys: String, CodingKey {
        case object
        case id
        case isLive = "livemode"
        case createdDate = "created"
        case isDeleted = "deleted"
        case lastDigits = "last_digits"
        case brand
        case name
        case bankName = "bank"
        case postalCode = "postal_code"
        case countryCode = "country"
        case city
        case financing
        case fingerPrint = "fingerprint"
        case expirationMonth = "expiration_month"
        case expirationYear = "expiration_year"
        case passSecurityCodeCheck = "security_code_check"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(object, forKey: .object)
        try container.encode(id, forKey: .id)
        try container.encode(isLive, forKey: .isLive)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(isDeleted, forKey: .isDeleted)
        try container.encode(lastDigits, forKey: .lastDigits)
        try container.encode(brand, forKey: .brand)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(bankName, forKey: .bankName)
        try container.encodeIfPresent(postalCode, forKey: .postalCode)
        try container.encodeIfPresent(countryCode, forKey: .countryCode)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(financing, forKey: .financing)
        try container.encode(fingerPrint, forKey: .fingerPrint)
        try container.encode(passSecurityCodeCheck, forKey: .passSecurityCodeCheck)
        try container.encodeIfPresent(expiration?.month, forKey: .expirationMonth)
        try container.encodeIfPresent(expiration?.year, forKey: .expirationYear)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        object = try container.decode(String.self, forKey: .object)
        id = try container.decode(String.self, forKey: .id)
        isLive = try container.decode(Bool.self, forKey: .isLive)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        lastDigits = try container.decode(LastDigits.self, forKey: .lastDigits)
        brand = try container.decode(CardBrand.self, forKey: .brand)
        name = try container.decode(String.self, forKey: .name)
        bankName = try container.decodeIfPresent(String.self, forKey: .bankName)
        postalCode = try container.decodeIfPresent(String.self, forKey: .postalCode)
        countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
        city = try container.decodeIfPresent(String.self, forKey: .city)
        financing = try container.decodeIfPresent(CardFinancing.self, forKey: .financing)
        fingerPrint = try container.decode(String.self, forKey: .fingerPrint)
        passSecurityCodeCheck = try container.decode(Bool.self, forKey: .passSecurityCodeCheck)
        let expirationMonth = try container.decodeIfPresent(Int.self, forKey: .expirationMonth)
        let expirationYear = try container.decodeIfPresent(Int.self, forKey: .expirationYear)
        if let expirationMonth = expirationMonth, let expirationYear = expirationYear {
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
    
    public let name: String
    public let fingerPrint: String
    
    public let financing: CardFinancing?
    
    public let passSecurityCodeCheck: Bool
}


extension CustomerCard {
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case isLive = "livemode"
        case createdDate = "created"
        case lastDigits = "last_digits"
        case brand
        case name
        case bankName = "bank"
        case postalCode = "postal_code"
        case countryCode = "country"
        case city
        case financing
        case fingerPrint = "fingerprint"
        case expirationMonth = "expiration_month"
        case expirationYear = "expiration_year"
        case passSecurityCodeCheck = "security_code_check"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(object, forKey: .object)
        try container.encode(location, forKey: .location)
        try container.encode(id, forKey: .id)
        try container.encode(isLive, forKey: .isLive)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(lastDigits, forKey: .lastDigits)
        try container.encode(brand, forKey: .brand)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(bankName, forKey: .bankName)
        try container.encodeIfPresent(postalCode, forKey: .postalCode)
        try container.encodeIfPresent(countryCode, forKey: .countryCode)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(financing, forKey: .financing)
        try container.encode(fingerPrint, forKey: .fingerPrint)
        try container.encode(passSecurityCodeCheck, forKey: .passSecurityCodeCheck)
        try container.encodeIfPresent(expiration?.month, forKey: .expirationMonth)
        try container.encodeIfPresent(expiration?.year, forKey: .expirationYear)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decode(String.self, forKey: .object)
        location = try container.decode(String.self, forKey: .location)
        id = try container.decode(String.self, forKey: .id)
        isLive = try container.decode(Bool.self, forKey: .isLive)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        lastDigits = try container.decode(LastDigits.self, forKey: .lastDigits)
        brand = try container.decode(CardBrand.self, forKey: .brand)
        name = try container.decode(String.self, forKey: .name)
        bankName = try container.decodeIfPresent(String.self, forKey: .bankName)
        postalCode = try container.decodeIfPresent(String.self, forKey: .postalCode)
        countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
        city = try container.decodeIfPresent(String.self, forKey: .city)
        financing = try container.decodeIfPresent(CardFinancing.self, forKey: .financing)
        fingerPrint = try container.decode(String.self, forKey: .fingerPrint)
        passSecurityCodeCheck = try container.decode(Bool.self, forKey: .passSecurityCodeCheck)
        let expirationMonth = try container.decodeIfPresent(Int.self, forKey: .expirationMonth)
        let expirationYear = try container.decodeIfPresent(Int.self, forKey: .expirationYear)
        if let expirationMonth = expirationMonth, let expirationYear = expirationYear {
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
    
    private enum CodingKeys: String, CodingKey {
        case name
        case expirationMonth = "expiration_month"
        case expirationYear = "expiration_year"
        case postalCode = "postal_code"
        case city
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


extension Card: Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
}


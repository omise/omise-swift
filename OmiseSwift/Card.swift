import Foundation

public enum CardBrand: String, Codable {
    case visa = "Visa"
    case masterCard = "MasterCard"
    case jcb = "JCB"
    case amex = "American Express"
    case diners = "Diners Club"
    case discover = "Discover"
    case maestro = "Maestro"
}


public enum CardFinancing: String, Codable {
    case credit
    case debit
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value {
        case "credit", "":
            self = .credit
        case "debit":
            self = .debit
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid Card Financing")
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
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = .customer(try container.decode(CustomerCard.self))
        } catch let error where error is DecodingError {
            self = .tokenized(try container.decode(TokenizedCard.self))
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
    }
    
    public func encode(to encoder: Encoder) throws {
        fatalError()
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decode(String.self, forKey: .object)
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
    
    public let name: String?
    public let fingerPrint: String
    
    public let financing: CardFinancing?
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
    }
    
    public func encode(to encoder: Encoder) throws {
        
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


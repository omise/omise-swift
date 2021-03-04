// swiftlint:disable file_length

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
    
    case credit
    case debit
    case unknown(String)
    
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
    
    public static let idPrefix: String = "card"
    
    public var object: String {
        switch self {
        case .tokenized(let card):
            return card.object
        case .customer(let card):
            return card.object
        }
    }
    
    public var id: DataID<Card> {
        switch self {
        case .tokenized(let card):
            return DataID(idString: card.id.idString)! // swiftlint:disable:this force_unwrapping
        case .customer(let card):
            return DataID(idString: card.id.idString)! // swiftlint:disable:this force_unwrapping
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
    
    public var billingAddress: BillingAddress {
        switch self {
        case .tokenized(let card):
            return card.billingAddress
        case .customer(let card):
            return card.billingAddress
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
    
    public var firstDigits: Digits? {
        switch self {
        case .tokenized(let card):
            return card.firstDigits
        case .customer(let card):
            return card.firstDigits
        }
    }
    
    public var lastDigits: Digits {
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

public struct TokenizedCard: OmiseIdentifiableObject, OmiseLiveModeObject, OmiseCreatedObject {
    public static let idPrefix: String = "card"
    
    public let object: String
    
    public let id: DataID<TokenizedCard>
    public let isLiveMode: Bool
    public let createdDate: Date
    
    public let isDeleted: Bool
    
    public let billingAddress: BillingAddress
    
    public let bankName: String?
    
    public let firstDigits: Digits?
    public let lastDigits: Digits
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
        case isLiveMode = "livemode"
        case createdDate = "created_at"
        case isDeleted = "deleted"
        case firstDigits = "first_digits"
        case lastDigits = "last_digits"
        case brand
        case name
        case bankName = "bank"
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
        try container.encode(isLiveMode, forKey: .isLiveMode)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(isDeleted, forKey: .isDeleted)
        try container.encodeIfPresent(firstDigits, forKey: .firstDigits)
        try container.encode(lastDigits, forKey: .lastDigits)
        try container.encode(brand, forKey: .brand)
        try container.encode(name, forKey: .name)
        
        try container.encodeIfPresent(bankName, forKey: .bankName)
        try container.encodeIfPresent(financing, forKey: .financing)
        try container.encode(fingerPrint, forKey: .fingerPrint)
        try container.encode(passSecurityCodeCheck, forKey: .passSecurityCodeCheck)
        try container.encodeIfPresent(expiration?.month, forKey: .expirationMonth)
        try container.encodeIfPresent(expiration?.year, forKey: .expirationYear)
        
        try billingAddress.encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        object = try container.decode(String.self, forKey: .object)
        id = try container.decode(DataID<TokenizedCard>.self, forKey: .id)
        isLiveMode = try container.decode(Bool.self, forKey: .isLiveMode)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        firstDigits = try container.decodeIfPresent(Digits.self, forKey: .firstDigits)
        lastDigits = try container.decode(Digits.self, forKey: .lastDigits)
        brand = try container.decode(CardBrand.self, forKey: .brand)
        name = try container.decode(String.self, forKey: .name)
        bankName = try container.decodeIfPresent(String.self, forKey: .bankName)
        billingAddress = try BillingAddress(from: decoder)
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

public struct CustomerCard: OmiseLocatableObject, OmiseIdentifiableObject, OmiseLiveModeObject, OmiseCreatedObject {
    public static let resourcePath = "/cards"
    public static let idPrefix: String = "card"
    
    public let location: String
    public let object: String
    
    public let id: DataID<CustomerCard>
    public let isLiveMode: Bool
    public let createdDate: Date
    
    public let isDeleted: Bool
    
    public let billingAddress: BillingAddress
    
    public let bankName: String?
    
    public let firstDigits: Digits?
    public let lastDigits: Digits
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
        case isLiveMode = "livemode"
        case createdDate = "created_at"
        case isDeleted = "deleted"
        case firstDigits = "first_digits"
        case lastDigits = "last_digits"
        case brand
        case name
        case bankName = "bank"
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
        try container.encode(isLiveMode, forKey: .isLiveMode)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(isDeleted, forKey: .isDeleted)
        try container.encodeIfPresent(firstDigits, forKey: .firstDigits)
        try container.encode(lastDigits, forKey: .lastDigits)
        try container.encode(brand, forKey: .brand)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(bankName, forKey: .bankName)
        try container.encodeIfPresent(financing, forKey: .financing)
        try container.encode(fingerPrint, forKey: .fingerPrint)
        try container.encode(passSecurityCodeCheck, forKey: .passSecurityCodeCheck)
        try container.encodeIfPresent(expiration?.month, forKey: .expirationMonth)
        try container.encodeIfPresent(expiration?.year, forKey: .expirationYear)
        
        try billingAddress.encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decode(String.self, forKey: .object)
        location = try container.decode(String.self, forKey: .location)
        id = try container.decode(DataID<CustomerCard>.self, forKey: .id)
        isLiveMode = try container.decode(Bool.self, forKey: .isLiveMode)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        firstDigits = try container.decodeIfPresent(Digits.self, forKey: .firstDigits)
        lastDigits = try container.decode(Digits.self, forKey: .lastDigits)
        brand = try container.decode(CardBrand.self, forKey: .brand)
        name = try container.decode(String.self, forKey: .name)
        bankName = try container.decodeIfPresent(String.self, forKey: .bankName)
        billingAddress = try BillingAddress(from: decoder)
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

extension CustomerCard: OmiseAPIChildObject {
    public typealias Parent = Customer
}


extension Customer {
    public func listCards(
        using client: APIClient, params: ListParams? = nil,
        callback: @escaping CustomerCard.ListRequest.Callback
        ) -> CustomerCard.ListRequest? {
        return self.list(keyPath: \.cards, using: client, params: params, callback: callback)
    }
    
    public func retrieveCard(
        using client: APIClient, id: DataID<CustomerCard>,
        callback: @escaping CustomerCard.RetrieveRequest.Callback
        ) -> CustomerCard.RetrieveRequest? {
        return CustomerCard.retrieve(using: client, parent: self, id: id, callback: callback)
    }
    
    public func updateCard(
        using client: APIClient, id: DataID<CustomerCard>, params: CardParams,
        callback: @escaping CustomerCard.UpdateRequest.Callback
        ) -> CustomerCard.UpdateRequest? {
        return CustomerCard.update(using: client, parent: self, id: id, params: params, callback: callback)
    }
    
    public func destroyCard(
        using client: APIClient, id: DataID<CustomerCard>,
        callback: @escaping CustomerCard.DestroyRequest.Callback
        ) -> CustomerCard.DestroyRequest? {
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

import Foundation


public enum RecipientType: String, Codable, Equatable {
    case individual
    case corporation
}


public struct Recipient: OmiseResourceObject, Equatable {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/recipients")
    
    public let object: String
    public let location: String

    public let id: String
    public let isLive: Bool
    public var createdDate: Date
    
    public let isVerified: Bool
    public let isActive: Bool
    
    public let name: String
    public let email: String?
    public let recipientDescription: String?
    
    public let type: RecipientType
    
    public let taxID: String?
    public let bankAccount: BankAccount
    
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case isLive = "livemode"
        case createdDate = "created"
        case isVerified = "verified"
        case isActive = "active"
        case name
        case email
        case recipientDescription = "description"
        case type
        case taxID = "tax_id"
        case bankAccount = "bank_account"
    }
}


public struct RecipientParams: APIJSONQuery {
    public var name: String?
    public var email: String?
    public var recipientDescription: String?
    public var type: RecipientType?
    public var taxID: String?
    public var bankAccount: BankAccountParams?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case email
        case recipientDescription = "description"
        case type
        case taxID = "tax_id"
        case bankAccount = "bank_account"
    }
    
    public init(name: String? = nil, email: String? = nil, recipientDescription: String? = nil,
                type: RecipientType? = nil, taxID: String? = nil, bankAccount: BankAccountParams? = nil) {
        self.name = name
        self.email = email
        self.recipientDescription = recipientDescription
        self.type = type
        self.taxID = taxID
        self.bankAccount = bankAccount
    }
}

extension RecipientParams {
    public init(createRecipientParamsWithName name: String, type: RecipientType, bankAccountName: String, bankAccountNumber: String, bankAccountBrand: String) {
        self.name = name
        self.type = type
        self.bankAccount = BankAccountParams(createNewBankAccountWithBrand: bankAccountBrand, accountNumber: bankAccountNumber, name: bankAccountName)
    }
}

extension Recipient: Creatable {
    public typealias CreateParams = RecipientParams
}

extension Recipient: Listable {}


public struct RecipientFilterParams: OmiseFilterParams {
    public var isActive: Bool?
    public var activatedDate: DateComponents?
    public var bankLastDigits: LastDigits?
    public var isDeleted: Bool?
    public var type: RecipientType?
    
    public init(isActive: Bool? = nil, activatedDate: DateComponents? = nil,
                bankLastDigits: LastDigits? = nil, isDeleted: Bool? = nil,
                type: RecipientType?) {
        self.isActive = isActive
        self.activatedDate = activatedDate
        self.bankLastDigits = bankLastDigits
        self.isDeleted = isDeleted
        self.type = type
    }
    
    private enum CodingKeys: String, CodingKey {
        case isActive = "active"
        case activatedDate = "activated_at"
        case bankLastDigits = "bank_last_digits"
        case isDeleted = "deleted"
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isActive = try container.decodeOmiseAPIValueIfPresent(Bool.self, forKey: .isActive)
        activatedDate = try container.decodeOmiseDateComponentsIfPresent(forKey: .activatedDate)
        bankLastDigits = try container.decodeIfPresent(LastDigits.self, forKey: .bankLastDigits)
        isDeleted = try container.decodeOmiseAPIValueIfPresent(Bool.self, forKey: .isDeleted)
        type = try container.decodeIfPresent(RecipientType.self, forKey: .type)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(isActive, forKey: .isActive)
        try container.encodeIfPresent(bankLastDigits, forKey: .bankLastDigits)
        try container.encodeOmiseDateComponentsIfPresent(activatedDate, forKey: .activatedDate)
        try container.encodeIfPresent(isDeleted, forKey: .isDeleted)
        try container.encodeIfPresent(type, forKey: .type)
    }
}


extension Recipient: Searchable {
    public typealias FilterParams = RecipientFilterParams
}


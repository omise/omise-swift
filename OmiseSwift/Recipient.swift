import Foundation



public struct Recipient: OmiseResourceObject, Equatable {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/recipients")
    
    public let object: String
    public let location: String
    
    public let id: String
    public let isLive: Bool
    public var createdDate: Date
    public let isDeleted: Bool
    
    public let isVerified: Bool
    public let isActive: Bool
    public let isDefault: Bool
    public let failureCode: FailureCode?
    
    public let name: String
    public let email: String?
    public let recipientDescription: String?
    
    public let type: RecipientType
    
    public let taxID: String?
    public let bankAccount: BankAccount
    
    public let metadata: JSONDictionary
    
    public enum RecipientType: String, Codable, Equatable {
        case individual
        case corporation
    }
    
    public enum FailureCode: String, Codable, Equatable {
        case nameMismatch = "name_mismatch"
        case accountNotFound = "account_not_found"
        case bankNotFound = "bank_not_found"
    }
    
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case isLive = "livemode"
        case createdDate = "created"
        case isDeleted = "deleted"
        case isVerified = "verified"
        case isActive = "active"
        case isDefault = "default"
        case failureCode = "failure_code"
        case name
        case email
        case recipientDescription = "description"
        case type
        case taxID = "tax_id"
        case bankAccount = "bank_account"
        case metadata
    }
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decode(String.self, forKey: .object)
        location = try container.decode(String.self, forKey: .location)
        id = try container.decode(String.self, forKey: .id)
        isLive = try container.decode(Bool.self, forKey: .isLive)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        isVerified = try container.decode(Bool.self, forKey: .isVerified)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        isDefault = try container.decode(Bool.self, forKey: .isDefault)
        failureCode = try container.decodeIfPresent(FailureCode.self, forKey: .failureCode)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        recipientDescription = try container.decodeIfPresent(String.self, forKey: .recipientDescription)
        type = try container.decode(RecipientType.self, forKey: .type)
        taxID = try container.decodeIfPresent(String.self, forKey: .taxID)
        bankAccount = try container.decode(BankAccount.self, forKey: .bankAccount)
        metadata = try container.decode(JSONDictionary.self, forKey: .metadata)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(object, forKey: .object)
        try container.encode(location, forKey: .location)
        try container.encode(id, forKey: .id)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(isLive, forKey: .isLive)
        try container.encode(isDeleted, forKey: .isDeleted)
        try container.encode(isVerified, forKey: .isVerified)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(isDefault, forKey: .isDefault)
        try container.encodeIfPresent(failureCode, forKey: .failureCode)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encodeIfPresent(recipientDescription, forKey: .recipientDescription)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(taxID, forKey: .taxID)
        try container.encode(bankAccount, forKey: .bankAccount)
        try container.encode(metadata, forKey: .metadata)
    }
}


public struct RecipientParams: APIJSONQuery {
    public var name: String?
    public var email: String?
    public var recipientDescription: String?
    public var type: Recipient.RecipientType?
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
                type: Recipient.RecipientType? = nil, taxID: String? = nil, bankAccount: BankAccountParams? = nil) {
        self.name = name
        self.email = email
        self.recipientDescription = recipientDescription
        self.type = type
        self.taxID = taxID
        self.bankAccount = bankAccount
    }
}

extension RecipientParams {
    public init(createRecipientParamsWithName name: String, type: Recipient.RecipientType, bankAccountName: String, bankAccountNumber: String, bankAccountBrand: String) {
        self.name = name
        self.type = type
        self.bankAccount = BankAccountParams(brand: bankAccountBrand, accountNumber: bankAccountNumber, name: bankAccountName)
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
    public var type: Recipient.RecipientType?
    
    public init(isActive: Bool? = nil, activatedDate: DateComponents? = nil,
                bankLastDigits: LastDigits? = nil, isDeleted: Bool? = nil,
                type: Recipient.RecipientType?) {
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
        type = try container.decodeIfPresent(Recipient.RecipientType.self, forKey: .type)
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


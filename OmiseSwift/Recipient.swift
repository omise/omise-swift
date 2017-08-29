import Foundation


public enum RecipientType: String, Codable {
    case individual
    case corporation
}


public struct Recipient: OmiseResourceObject {
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
}


public struct RecipientParams: APIJSONQuery {
    public var name: String?
    public var email: String?
    public var recipientDescription: String?
    public var type: RecipientType?
    public var taxID: String?
    public var bankAccount: BankAccountParams?
    
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
    public var type: RecipientType?
    
    public init(type: RecipientType?) {
        self.type = type
    }
}

extension Recipient: Searchable {
    public typealias FilterParams = RecipientFilterParams
}


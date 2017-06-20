import Foundation


public enum RecipientType: String, Decodable {
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


extension Recipient {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Recipient.parseOmiseResource(JSON: json) else {
                return nil
        }
        
        guard let name = json["name"] as? String, let type = EnumConverter<RecipientType>.convert(fromAttribute: json["type"]),
            let account = json["bank_account"].flatMap(BankAccount.init(JSON:)),
            let isActive = json["active"] as? Bool, let isVerified = json["verified"] as? Bool else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate) = omiseObjectProperties
        self.name = name
        self.type = type
        self.bankAccount = account
        self.isActive = isActive
        self.isVerified = isVerified
        self.email = json["email"] as? String
        self.recipientDescription = json["description"] as? String
        self.taxID = json["tax_id"] as? String
    }
}


public struct RecipientParams: APIJSONQuery {
    public var name: String?
    public var email: String?
    public var recipientDescription: String?
    public var type: RecipientType?
    public var taxID: String?
    public var bankAccount: BankAccountParams?
    
    public var json: JSONAttributes {
        return Dictionary<String, Any>.makeFlattenDictionaryFrom([
            "name": name,
            "email": email,
            "description": recipientDescription,
            "type": type?.rawValue,
            "tax_id": taxID,
            "bank_account": bankAccount
        ])
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
    public var type: RecipientType?
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "type": type?.rawValue
            ])
    }
    
    public init(type: RecipientType?) {
        self.type = type
    }
    
    public init(JSON: [String : Any]) {
        self.init(type: (JSON["type"] as? String).flatMap(RecipientType.init(rawValue:)))
    }
}

extension Recipient: Searchable {
    public typealias FilterParams = RecipientFilterParams
}


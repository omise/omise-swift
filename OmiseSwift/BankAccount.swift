import Foundation

public struct BankAccount: OmiseObject {
    public let object: String
    
    public let bank: Bank
    public let accountNumber: String?
    public let lastDigits: LastDigits
    public let name: String
}

extension BankAccount {
    private enum CodingKeys: String, CodingKey {
        case object
        case bankCode = "bank_code"
        case bankBrand = "brand"
        case branchCode = "branch_code"
        case accountNumber = "number"
        case lastDigits = "last_digits"
        case name
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decode(String.self, forKey: .object)
        name = try container.decode(String.self, forKey: .name)
        lastDigits = try container.decode(LastDigits.self, forKey: .lastDigits)
        accountNumber = try container.decodeIfPresent(String.self, forKey: .object)
        
        let bankID = try container.decodeIfPresent(String.self, forKey: .bankBrand) ??
         container.decode(String.self, forKey: .bankCode)
        let branchCode = try container.decodeIfPresent(String.self, forKey: .branchCode)
        guard let bank = Bank(bankID: bankID, branchCode: branchCode) else {
            let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid Bank data")
            throw DecodingError.dataCorrupted(context)
        }
        self.bank = bank
    }
}

public struct BankAccountParams: APIJSONQuery {
    public var brand: String?
    public var accountNumber: String?
    public var name: String?
    
    public var json: JSONAttributes {
        return Dictionary<String, Any>.makeFlattenDictionaryFrom([
            "brand": brand,
            "number": accountNumber,
            "name": name,
            ])
    }
    
    public init(brand: String? = nil, accountNumber: String? = nil, name: String? = nil) {
        self.brand = brand
        self.accountNumber = accountNumber
        self.name = name
    }
}


extension BankAccountParams {
    public init(createNewBankAccountWithBrand brand: String, accountNumber: String, name: String) {
        self.brand = brand
        self.name = name
        self.accountNumber = accountNumber
    }
}


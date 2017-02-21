import Foundation

public struct BankAccount: OmiseObject {
    public let object: String
    
    public let bank: Bank
    public let accountNumber: String?
    public let lastDigits: LastDigits
    public let name: String
}

extension BankAccount {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let object = BankAccount.parseObject(JSON: json),
            let bank = (json["brand"] as? String ?? json["bank_code"] as? String).flatMap({Bank(bankID: $0, branchCode: json["branch_code"] as? String) }),
            let name = json["name"] as? String,
            let lastDigits = json["last_digits"].flatMap(LastDigitsConverter.convert(fromAttribute:)) else {
                return nil
        }
        
        self.object = object
        self.bank = bank
        self.name = name
        self.lastDigits = lastDigits
        self.accountNumber = json["number"] as? String
    }
}

public struct BankAccountParams: APIParams {
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


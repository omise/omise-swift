import Foundation

public struct BankAccount: OmiseObject {
    public let object: String
    
    public let brand: String
    public let accountNumber: String
    public let lastDigits: LastDigits
    public let name: String
}

extension BankAccount {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let object = BankAccount.parseObject(JSON: json),
            let brand = json["brand"] as? String,
            let name = json["name"] as? String,
            let accountNumber = json["number"] as? String,
            let lastDigits = json["last_digits"].flatMap(LastDigitsConverter.convert(fromAttribute:)) else {
                return nil
        }
        
        self.object = object
        self.brand = brand
        self.name = name
        self.accountNumber = accountNumber
        self.lastDigits = lastDigits
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


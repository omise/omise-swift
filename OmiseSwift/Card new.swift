import Foundation

public enum CardBrand: String {
    case visa = "Visa"
    case masterCard = "MasterCard"
    case jcb = "JCB"
    case amex = "American Express"
    case diners = "Diners Club"
    case discover = "Discover"
    case maestro = "Maestro"
}


public enum CardFinancing: String {
    case credit
    case debit
}


public struct Card: OmiseResourceObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(parentType: Customer.self, path: "/cards")
    
    public let location: String
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
}


extension Card {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any] else {
            return nil
        }
        
        guard let omiseObjectProperties = Card.parseOmiseResource(JSON: json),
            let lastDigits = LastDigitsConverter.convert(fromAttribute: json["last_digits"]),
            let cardBrand: CardBrand = EnumConverter.convert(fromAttribute: json["brand"]),
            let fingerPrint = json["fingerprint"] as? String else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate, self.isDeleted) = omiseObjectProperties
        self.lastDigits = lastDigits
        self.brand = cardBrand
        
        self.name = json["name"] as? String
        self.bankName = json["bank"] as? String
        self.postalCode = json["postal_code"] as? String
        self.countryCode = json["country"] as? String
        self.city = json["city"] as? String
        
        self.financing = EnumConverter.convert(fromAttribute: json["financing"])
        self.fingerPrint = fingerPrint
        
        if let expirationMonth = json["expiration_month"] as? Int, let expirationYear = json["expiration_year"] as? Int {
            self.expiration = (month: expirationMonth, year: expirationYear)
        } else {
            self.expiration = nil
        }
    }
}


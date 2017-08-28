import Foundation

public struct Account: OmiseLocatableObject, OmiseIdentifiableObject, OmiseCreatableObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/account")
    
    public let object: String
    public let location: String
    public let id: String
    public let createdDate: Date
    
    public let email: String
    
    public let currency: Currency
    public let supportedCurrencies: Set<Currency>
}


extension Account: SingletonRetrievable {}


import Foundation

public struct Account: OmiseResourceObject, Equatable {
    public static let resourcePath = "/account"
    public static let idPrefix: String = "account"
    
    public let object: String
    public let location: String
    public let id: DataID<Account>
    public let isLiveMode: Bool
    public let createdDate: Date
    
    public let email: String
    public let teamID: String
    
    public let currency: Currency
    public let supportedCurrencies: Set<Currency>
    
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case isLiveMode = "livemode"
        case createdDate = "created_at"
        case email
        case teamID = "team"
        case currency
        case supportedCurrencies = "supported_currencies"
    }
}

extension Account: OmiseAPIPrimaryObject {}
extension Account: SingletonRetrievable {}


import Foundation


public struct BillingAddress: Codable, Equatable {
    public let street1: String?
    public let street2: String?
    public let city: String?
    public let state: String?
    public let postalCode: String?
    public let countryCode: String?
    public let phoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case street1
        case street2
        case city
        case state
        case postalCode = "postal_code"
        case countryCode = "country"
        case phoneNumber = "phone_number"
    }
}

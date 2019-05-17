import Foundation

public struct Forex: OmiseLocatableObject, OmiseLiveModeObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "forex")
    public let object: String
    public let location: String
    public let isLive: Bool
    
    public let base: Currency
    public let quote: Currency
    public let rate: Double
}

extension Forex {
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case isLive = "livemode"
        case base
        case quote
        case rate
    }
}


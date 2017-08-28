import Foundation

public struct Forex: OmiseLocatableObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "forex")
    public let object: String
    public let location: String
    
    public let from: Currency
    public let to: Currency
    public let rate: Double
}


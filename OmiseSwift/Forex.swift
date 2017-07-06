import Foundation

public struct Forex: OmiseLocatableObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "forex")
    public let object: String
    public let location: String
    
    public let from: Currency
    public let to: Currency
    public let rate: Double
    
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let properties = Forex.parseLocationResource(JSON: json) else {
                return nil
        }
        
        (self.object, self.location) = properties
        
        guard let from = (json["from"] as? String).flatMap(Currency.init(code:)),
            let to = (json["to"] as? String).flatMap(Currency.init(code:)),
            let rate = json["rate"] as? Double else {
                return nil
        }
        
        self.from = from
        self.to = to
        self.rate = rate
    }
}


import Foundation


public struct Link: OmiseResourceObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/links")
    
    public let object: String
    
    public let location: String
    public let id: String
    public let isLive: Bool
    public let createdDate: Date
    public let isDeleted: Bool
    
    public let value: Value
    public let isUsed: Bool
    public let isMultiple: Bool
    public let title: String
    public let linkDescription: String
    public let charges: ListProperty<Charge>
    public let paymentURL: URL
}


extension Link {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Charge.parseOmiseResource(JSON: json) else {
                return nil
        }
        
        guard let value = Value(JSON: json),
            let isUsed = json["used"] as? Bool, let isMultiple = json["multiple"] as? Bool,
            let title = json["title"] as? String, let linkDescription = json["description"] as? String,
            let charges = json["charges"].flatMap(ListProperty<Charge>.init(JSON:)),
            let paymentURL = (json["payment_uri"] as? String).flatMap(URL.init(string:)) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate, self.isDeleted) = omiseObjectProperties
        self.value = value
        self.isUsed = isUsed
        self.isMultiple = isMultiple
        self.title = title
        self.linkDescription = linkDescription
        self.charges = charges
        self.paymentURL = paymentURL
    }
}


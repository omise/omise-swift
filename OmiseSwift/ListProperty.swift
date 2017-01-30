import Foundation

public struct ListProperty<Item: OmiseObject>: OmiseObject {
    public let object: String
    
    public var from: Date
    public var to: Date
    
    public let limit: Int
    public let total: Int
    
    public var offset: Int
    
    public var data: [Item]
}


extension ListProperty {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any] ,
            let object = Charge.parseObject(JSON: json) else {
            return nil
        }
        
        guard let from = json["from"].flatMap(DateConverter.convert(fromAttribute:)),
            let to = json["to"].flatMap(DateConverter.convert(fromAttribute:)),
            let limit = json["limit"] as? Int, let total = json["total"] as? Int, let offset = json["offset"] as? Int,
            let data = (json["data"] as? [Any])?.flatMap(Item.init) else {
                return nil
        }
        
        self.object = object
        self.from = from
        self.to = to
        self.limit = limit
        self.total = total
        self.offset = offset
        self.data = data
    }
}

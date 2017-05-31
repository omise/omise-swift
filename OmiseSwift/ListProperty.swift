import Foundation

public struct ListProperty<Item: OmiseObject>: OmiseObject {
    public let object: String
    
    public var from: Date
    public var to: Date
    
    public let limit: Int
    public let total: Int
    
    public var offset: Int
    
    public var data: [Item]
    
    public subscript(index: Array<Item>.Index) -> Item {
        return data[index]
    }
    
    public subscript(bounds: Range<Array<Item>.Index>) -> ArraySlice<Item> {
        return data[bounds]
    }
}

extension ListProperty: RandomAccessCollection {
    /// The position of the first element in a nonempty collection.
    ///
    /// If the collection is empty, `startIndex` is equal to `endIndex`.
    public var startIndex: (Array<Item>.Index) {
        return data.startIndex
    }
    
    public var endIndex: (Array<Item>.Index) {
        return data.endIndex
    }
}


extension ListProperty {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any] ,
            let object = ListProperty.parseObject(JSON: json) else {
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


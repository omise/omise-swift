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



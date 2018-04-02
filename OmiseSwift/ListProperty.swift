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

extension ListProperty: RandomAccessCollection {
    public subscript(position: (Array<Item>.Index)) -> Item {
        return data[position]
    }
    public subscript(bounds: Range<Array<Item>.Index>) -> ArraySlice<Item> {
        return data[bounds]
    }
    
    public var startIndex: (Array<Item>.Index) {
        return data.startIndex
    }
    
    public var endIndex: (Array<Item>.Index) {
        return data.endIndex
    }
    
    public func index(before i: Array<Item>.Index) -> Array<Item>.Index {
        return data.index(before: i)
    }
    
    public func index(after i: (Array<Item>.Index)) -> (Array<Item>.Index) {
        return data.index(after: i)
    }
    
    public func index(_ i: (Array<Item>.Index), offsetBy n: Int) -> (Array<Item>.Index) {
        return data.index(i, offsetBy: n)
    }
}

extension ListProperty: Equatable where Item: Equatable {
    public static func == (lhs: ListProperty<Item>, rhs: ListProperty<Item>) -> Bool {
        return lhs.object == rhs.object &&
            lhs.from == rhs.from &&
            lhs.to == rhs.to &&
            lhs.limit == rhs.limit &&
            lhs.total == rhs.total &&
            lhs.offset == rhs.offset &&
            lhs.data == rhs.data
    }
}


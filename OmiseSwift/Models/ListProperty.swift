import Foundation

public struct ListProperty<Item: OmiseObject>: OmiseObject {
    public let object: String
    
    public let location: String
    
    public var from: Date
    public var to: Date
    
    public let limit: Int
    public let total: Int
    
    public var offset: Int
    
    public var data: [Item]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        object = try container.decode(String.self, forKey: .object)
        location = try container.decode(String.self, forKey: .location)
        from = try container.decode(Date.self, forKey: .from)
        to = try container.decode(Date.self, forKey: .to)
        limit = try container.decode(Int.self, forKey: .limit)
        total = try container.decode(Int.self, forKey: .total)
        offset = try container.decode(Int.self, forKey: .offset)

        let decodedData = try container.decode([DecodingResult<Item>].self, forKey: .data)
        data = decodedData.compactMap { try? $0.result.get() }
    }
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

private struct DecodingResult<T: Decodable>: Decodable {
    let result: Result<T, Error>

    init(from decoder: Decoder) throws {
        result = Result { try T(from: decoder) }
    }
}

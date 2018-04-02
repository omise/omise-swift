import Foundation

public struct SearchResult<Item: Searchable & OmiseObject>: OmiseLocatableObject {
    public static var resourceInfo: ResourceInfo {
        return ResourceInfo(path: "/search")
    }
    
    public let object: String
    public let location: String
    public let scope: String
    public let query: String
    public let page: Int
    public let totalPage: Int
    
    public let filters: Item.FilterParams
    public var data: [Item]
}

extension SearchResult: RandomAccessCollection {
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

extension SearchResult {
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case scope
        case query
        case page
        case totalPage = "total_pages"
        case filters
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decode(String.self, forKey: .object)
        location = try container.decode(String.self, forKey: .location)
        scope = try container.decode(String.self, forKey: .scope)
        query = try container.decode(String.self, forKey: .query)
        page = try container.decode(Int.self, forKey: .page)
        totalPage = try container.decode(Int.self, forKey: .totalPage)
        filters = try container.decode(Item.FilterParams.self, forKey: .filters)
        data = try container.decode([Item].self, forKey: .data)
    }
}


import Foundation

public struct SearchResult<Item: Searchable & OmiseObject>: OmiseLocatableObject {
    public static var resourcePath: String {
        return "/search"
    }
    
    public let object: String
    public let location: String
    public let scope: String
    public let query: String
    public let page: Int
    public let totalPage: Int
    
    public let numberOfItemsPerPage: Int
    public let total: Int
    
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
        case numberOfItemsPerPage = "per_page"
        case total
        case filters
        case data
    }
}

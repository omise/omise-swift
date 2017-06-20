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


extension SearchResult {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseProperties = SearchResult.parseLocationResource(JSON: json),
            let scope = json["scope"] as? String,
            let query = json["query"] as? String,
            let page = json["page"] as? Int,
            let totalPage = json["total_pages"] as? Int,
            let filters = (json["filters"] as? [String: Any]).flatMap(Item.FilterParams.init(JSON:)),
            let data = (json["data"] as? [Any])?.flatMap(Item.init) else {
                return nil
        }
        
        (self.object, self.location) = omiseProperties
        self.scope = scope
        self.query = query
        self.page = page
        self.totalPage = totalPage
        self.filters = filters
        self.data = data
    }
    
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


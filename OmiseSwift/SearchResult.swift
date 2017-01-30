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
}


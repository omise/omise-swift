import Foundation


public class Search<TItem: Searchable & OmiseResourceObject> {
    public var loadedPages = 0..<0
    
    public let scope: String
    public let query: String?
    public let filters: TItem.FilterParams?
    public let order: Ordering
    
    private(set) public var totalPages: Int = 0
    private(set) public var data: [TItem] = [] {
        didSet {
            dataUpdatedHandler?(data)
        }
    }
    public var dataUpdatedHandler: (([TItem]) -> Void)?
    
    public var loadedFirstPage: Int {
        return loadedPages.first ?? loadedPages.lowerBound
    }
    
    public init(searchParams: SearchParams<TItem.FilterParams>) {
        self.scope = searchParams.scope
        self.query = searchParams.query
        self.order = searchParams.order ?? .chronological
        self.filters = searchParams.filter
    }
    
    public init(result: SearchResult<TItem>, order: Ordering) {
        self.scope = result.scope
        self.query = result.query
        self.filters = result.filters
        self.totalPages = result.totalPage
        self.order = order
        self.loadedPages = CountableRange(result.page...result.page)
        self.data = result.data
    }
    
    public func insert(from value: SearchResult<TItem>) -> [TItem] {
        self.totalPages = value.totalPage
        
        let valuesRange = range(fromOffset: value.page, limit: 1)
        
        guard let side = loadedPages.side(from: valuesRange) else {
            dataUpdatedHandler?(data)
            return []
        }
        
        if side == .lower {
            data.insert(contentsOf: value.data, at: data.startIndex)
        } else {
            data.append(contentsOf: value.data)
        }
        
        loadedPages = combine(range: loadedPages, with: valuesRange)
        
        return value.data
    }

}


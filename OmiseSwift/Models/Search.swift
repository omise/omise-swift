import Foundation


public class Search<TItem: Searchable & OmiseResourceObject> {
    
    public let scope: String
    public let query: String?
    public let filters: TItem.FilterParams?
    public let order: Ordering
    
    public var loadedPages = 0..<0
    private(set) public var total: Int = 0
    private(set) public var numberOfItemsPerPage: Int = 0
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
        self.numberOfItemsPerPage = result.numberOfItemsPerPage
        self.totalPages = result.totalPage
        self.total = result.total
        self.order = order
        self.loadedPages = CountableRange(result.page...result.page)
        self.data = result.data
    }
    
    
    public func setList(from result: SearchResult<TItem>) -> [TItem] {
        self.data = result.data
        self.numberOfItemsPerPage = result.numberOfItemsPerPage
        self.total = result.total
        self.totalPages = result.totalPage
        
        let offset = result.page
        loadedPages = range(fromOffset: offset, limit: 1)
        
        return result.data
    }
    
    public func setData(from result: SearchResult<TItem>) -> [TItem] {
        guard numberOfItemsPerPage > 0 && total > 0 else {
            return setList(from: result)
        }
        
        let updatedData = result.data
        
        guard let firstUpdatedItem = updatedData.first, let lastUpdatedItem = updatedData.last else {
            return []
        }
        
        var indexOfFirstUpdatedItem = self.data.firstIndex(where: { $0.location == firstUpdatedItem.location }) ?? self.data.startIndex
        var indexOfLastUpdatedItem = self.data.firstIndex(where: { $0.location == lastUpdatedItem.location }) ?? self.data.endIndex
        
        if indexOfFirstUpdatedItem.distance(to: indexOfLastUpdatedItem) < 0 {
            swap(&indexOfFirstUpdatedItem, &indexOfLastUpdatedItem)
        }
        
        let replacingRange = indexOfFirstUpdatedItem..<indexOfLastUpdatedItem
        self.data[replacingRange] = ArraySlice(result.data)
        
        return updatedData
    }
    
    public func clearData() {
        self.data = []
        self.totalPages = 0
        self.total = 0
        self.numberOfItemsPerPage = 0
        self.loadedPages = 0..<0
    }
    
    
    public func insert(from value: SearchResult<TItem>) -> [TItem] {
        self.totalPages = value.totalPage
        self.numberOfItemsPerPage = value.numberOfItemsPerPage
        let valuesRange = range(fromOffset: value.page, limit: 1)
        
        guard !loadedPages.contains(value.page), let side = loadedPages.side(from: valuesRange) else {
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


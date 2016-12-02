import Foundation


public class List<TItem: OmiseObject> {
    private(set) public var from: Date?
    private(set) public var to: Date?
    var loadedIndices = 0..<0
    public let order: Ordering
    
    public var limit: Int = 0
    private(set) public var total: Int = 0
    private(set) public var data: [TItem] = [] {
        didSet {
            dataUpdatedHandler?(data)
        }
    }
    
    let endpoint: Endpoint
    let paths: [String]
    
    public var dataUpdatedHandler: (([TItem]) -> Void)?
    
    public var loadedFirstIndex: Int {
        return loadedIndices.first ?? loadedIndices.lowerBound
    }
    
    public init(endpoint: Endpoint, paths: [String], order: Ordering?, list: OmiseList<TItem>? = nil) {
        self.endpoint = endpoint
        self.paths = paths
        
        self.data = list?.data ?? []
        self.limit = list?.limit ?? 0
        self.total = list?.total ?? 0
      
        if let order = order {
          self.order = order
        } else if let from = list?.from, let to = list?.to {
            self.order = from.compare(to) == .orderedDescending ? .reverseChronological : .chronological
        } else {
            self.order = .chronological
        }
        self.from = list?.from
        self.to = list?.to
        
        let offset = list?.offset ?? 0
        loadedIndices = range(fromOffset: offset, limit: list?.data.count ?? 0)
    }
    
    public func insert(from value: OmiseList<TItem>) -> [TItem] {
        guard let offset = value.offset, let limit = value.limit else { return [] }
        if let total = value.total {
            self.total = total
        }
        let valuesRange = range(fromOffset: offset, limit: min(limit, value.data.count))
        self.limit = limit
        
        guard let side = loadedIndices.side(from: valuesRange) else { return [] }
        if side == .lower {
            let insertingCount = valuesRange.prefix(upTo: loadedIndices.lowerBound).count
            data.insert(contentsOf: value.data.prefix(insertingCount), at: data.startIndex)
        } else { 
            data.append(contentsOf: value.data)
        }
        
        loadedIndices = combine(range: loadedIndices, with: valuesRange)
        
        return value.data
    }
}
 

func range(fromOffset offset: Int, limit: Int) -> CountableRange<Int> {
    return offset..<(offset + limit)
}

func combine(range: CountableRange<Int>, with anotherRange: CountableRange<Int>) -> CountableRange<Int> {
    guard range.side(from: anotherRange) != nil || range.overlaps(anotherRange) else { return range }
    
    switch (range.isEmpty, anotherRange.isEmpty) {
    case (false, false):
        return min(range.lowerBound, anotherRange.lowerBound)..<max(range.upperBound, anotherRange.upperBound)
    case (true, false):
        return anotherRange
    default:
        return range
    }
}


enum Side {
    case lower
    case upper
}

extension CountableRange where Bound: Strideable {
    func side(from range: CountableRange<Bound>) -> Side? {
        guard let first = first, let last = last, !range.isEmpty else {
            return .upper
        }
        let lowerBound = first.advanced(by: -1)
        let upperBound = last.advanced(by: 1)
        if range.contains(lowerBound) {
            return .lower
        } else if range.contains(upperBound) {
            return .upper
        } else {
            return nil
        }
    }
}


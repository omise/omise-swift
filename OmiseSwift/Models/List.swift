import Foundation


public class List<TItem: OmiseLocatableObject & Listable> {
    private(set) public var from: Date
    private(set) public var to: Date
    var loadedIndices = 0..<0
    public let order: Ordering
    
    private(set) public var limit: Int = 0
    private(set) public var total: Int = 0
    private(set) public var data: [TItem] = [] {
        didSet {
            dataUpdatedHandler?(data)
        }
    }
    
    let intiitalEndpoint: APIEndpoint<ListProperty<TItem>>
    
    public var dataUpdatedHandler: (([TItem]) -> Void)?
    
    public var loadedFirstIndex: Int {
        return loadedIndices.first ?? loadedIndices.lowerBound
    }
    
    public init(listEndpoint: APIEndpoint<ListProperty<TItem>>, list: ListProperty<TItem>? = nil) {
        self.intiitalEndpoint = listEndpoint
        
        let limitParam: Int?
        let offsetParam: Int?
        let orderingParam: Ordering?
        if case .get(let params) = listEndpoint.parameter,
            let listParams = params as? ListParams {
            limitParam = listParams.limit
            offsetParam = listParams.offset
            orderingParam = listParams.order
        } else {
            limitParam = nil
            offsetParam = nil
            orderingParam = nil
        }
        
        self.limit = limitParam ?? list?.limit ?? 0
        self.data = list?.data ?? []
        self.total = list?.total ?? 0
        
        if let order = orderingParam {
            self.order = order
        } else if let from = list?.from, let to = list?.to {
            self.order = from.compare(to) == .orderedDescending ? .reverseChronological : .chronological
        } else {
            self.order = .chronological
        }
        self.from = list?.from ?? Date.distantPast
        self.to = list?.to ?? Date.distantPast
        
        let offset = offsetParam ?? list?.offset ?? 0
        loadedIndices = range(fromOffset: offset, count: list?.data.count ?? 0)
    }
    
    public func setList(from list: ListProperty<TItem>) -> [TItem] {
        self.data = list.data
        self.limit = list.limit
        self.total = list.total
        self.from = list.from
        self.to = list.to
        
        let offset = list.offset
        loadedIndices = range(fromOffset: offset, count: list.data.count)
        
        return list.data
    }
    
    public func setData(from list: ListProperty<TItem>) -> [TItem] {
        guard limit > 0 && total > 0 else {
            return setList(from: list)
        }
        
        let updatedData = list.data
        
        guard let firstUpdatedItem = updatedData.first, let lastUpdatedItem = updatedData.last else {
            return []
        }
        
        var indexOfFirstUpdatedItem = self.data.firstIndex(where: {
            $0.location == firstUpdatedItem.location }) ?? self.data.startIndex
        var indexOfLastUpdatedItem = self.data.firstIndex(where: {
            $0.location == lastUpdatedItem.location }) ?? self.data.endIndex
        
        if indexOfFirstUpdatedItem.distance(to: indexOfLastUpdatedItem) < 0 {
            swap(&indexOfFirstUpdatedItem, &indexOfLastUpdatedItem)
        }
        
        let replacingRange = indexOfFirstUpdatedItem..<indexOfLastUpdatedItem
        self.data[replacingRange] = ArraySlice(list.data)
        
        loadedIndices = range(fromOffset: list.offset, count: list.data.count)
        
        return updatedData
    }
    
    public func clearData() {
        self.data = []
        self.limit = 0
        self.total = 0
        self.from = Date.distantPast
        self.to = Date.distantPast
        self.loadedIndices = 0..<0
    }
    
    public func insert(from value: ListProperty<TItem>) -> [TItem] {
        let offset = value.offset
        let limit = value.limit
        
        let total = value.total
        self.total = total
        
        let valuesRange = range(fromOffset: offset, count: Swift.min(limit, value.data.count))
        self.limit = limit
        
        guard let side = loadedIndices.side(from: valuesRange) else {
            dataUpdatedHandler?(data)
            return []
        }
        if side == .lower {
            let insertingCount = valuesRange.prefix(upTo: loadedIndices.lowerBound).count
            data.insert(contentsOf: value.data.prefix(insertingCount), at: data.startIndex)
        } else {
            data.append(contentsOf: value.data)
        }
        
        loadedIndices = combine(range: loadedIndices, with: valuesRange)
        
        return value.data
    }
    
    public func merge(with list: ListProperty<TItem>) -> [TItem] {
        guard limit > 0 && total > 0 else {
            return setList(from: list)
        }
        
        let updatedData = list.data
        
        guard let firstUpdatedItem = updatedData.first, let lastUpdatedItem = updatedData.last else {
            return []
        }
        
        var indexOfFirstUpdatedItem = self.data.firstIndex(where: { $0.location == firstUpdatedItem.location })
        var indexOfLastUpdatedItem = self.data.firstIndex(where: { $0.location == lastUpdatedItem.location })
        
        if let indexOfFirst = indexOfFirstUpdatedItem,
            let indexOfLast = indexOfLastUpdatedItem,
            indexOfFirst.distance(to: indexOfLast) < 0 {
            swap(&indexOfFirstUpdatedItem, &indexOfLastUpdatedItem)
        }
        
        switch (indexOfFirstUpdatedItem, indexOfLastUpdatedItem) {
        case (nil, nil):
            return self.insert(from: list)
        case (nil, let indexOfLastItem?):
            // `list` is at the front of the merging list
            let replacingRange = data.startIndex...indexOfLastItem
            let newItemsCount = list.data.count - replacingRange.count
            data[replacingRange] = ArraySlice(list.data)
            loadedIndices = expand(range: loadedIndices, on: .upper, for: newItemsCount)
        case (let indexOfFirstItem?, nil):
            // `list` is at the back of the merging list
            let replacingRange = indexOfFirstItem..<data.endIndex
            let newItemsCount = list.data.count - replacingRange.count
            data[replacingRange] = ArraySlice(list.data)
            loadedIndices = expand(range: loadedIndices, on: .lower, for: newItemsCount)
        case (let indexOfFirstItem?, let indexOfLastItem?):
            // `list` is at the middle of the merging list
            let replacingRange = indexOfFirstItem...indexOfLastItem
            let newItemsCount = list.data.count - replacingRange.count
            data[replacingRange] = ArraySlice(list.data)
            loadedIndices = expand(range: loadedIndices, on: .upper, for: newItemsCount)
        }
        
        return list.data
    }
}


extension List: RandomAccessCollection {
    public subscript(index: Array<TItem>.Index) -> TItem {
        return data[index]
    }
    
    public subscript(bounds: Range<Array<TItem>.Index>) -> ArraySlice<TItem> {
        return data[bounds]
    }
    
    public var startIndex: (Array<TItem>.Index) {
        return data.startIndex
    }
    
    public var endIndex: (Array<TItem>.Index) {
        return data.endIndex
    }
    
    public func index(before i: (Array<TItem>.Index)) -> (Array<TItem>.Index) {
        return data.index(before: i)
    }
    
    public func index(after i: (Array<TItem>.Index)) -> (Array<TItem>.Index) {
        return data.index(after: i)
    }
    
    public func index(_ i: (Array<TItem>.Index), offsetBy n: Int) -> (Array<TItem>.Index) {
        return data.index(i, offsetBy: n)
    }
}


func range(fromOffset offset: Int, count: Int) -> CountableRange<Int> {
    return offset..<(offset + count)
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


func expand(range: CountableRange<Int>, on side: Side, for length: Int) -> CountableRange<Int> {
    switch side {
    case .lower:
        return range.lowerBound.advanced(by: -length)..<range.upperBound
    case .upper:
        return range.lowerBound..<range.upperBound.advanced(by: length)
    }
}


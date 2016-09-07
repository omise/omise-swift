import Foundation

public typealias JSONAttributes = [String: NSObject]

public protocol AttributesContainer: class {
    var attributes: JSONAttributes { get set }
    var children: [String: AttributesContainer] { get set }
    
    init(attributes: JSONAttributes)
}

// convenience getters/setters
public extension AttributesContainer {
    public init(id: String) {
        self.init(attributes: ["id": id])
    }
    
    public func get<TConv: Converter>(key: String, _ converter: TConv.Type) -> TConv.Target? {
        return TConv.convertFromAttribute(self.attributes[key])
    }
    
    public func set<TConv: Converter>(key: String, _ converter: TConv.Type, toValue value: TConv.Target?) {
        self.attributes[key] = TConv.convertToAttribute(value)
    }
    
    // TODO: Cache lists
    public func getList<TItem: AttributesContainer>(key: String, _ itemType: TItem.Type) -> [TItem] {
        let items = self.attributes[key] as? [JSONAttributes] ?? []
        return items.map({ (attributes) -> TItem in TItem(attributes: attributes) })
    }
    
    public func setList<TItem: AttributesContainer>(key: String, _ itemType: TItem.Type, toValue value: [TItem]) {
        attributes[key] = value.map({ (model) -> JSONAttributes in model.attributes })
    }
    
    public func getChild<TChild: AttributesContainer>(key: String, _ childType: TChild.Type) -> TChild? {
        if let child = children[key] as? TChild {
            return child
        }
        
        let child = childType.init(attributes: (attributes[key] as? JSONAttributes) ?? [:])
        children[key] = child
        return child
    }
    
    public func setChild<TChild: AttributesContainer>(key: String, _ childType: TChild.Type, toValue child: TChild?) {
        children[key] = child
    }
}

// attributes normalization
public extension AttributesContainer {
    public var normalizedAttributes: JSONAttributes {
        return normalizeAttributesWithPrefix(nil)
    }
    
    private func normalizeAttributesWithPrefix(parentPrefix: String?) -> JSONAttributes {
        var result: JSONAttributes = [:]
        for (childPrefix, child) in children {
            let childAttributes = child.normalizeAttributesWithPrefix(stitchKeys(parentPrefix, key: childPrefix))
            for (key, value) in childAttributes {
                result[key] = value
            }
        }
        
        for (key, value) in attributes {
            result[stitchKeys(parentPrefix, key: key)] = value
        }
        
        return result
    }
    
    private func stitchKeys(prefix: String?, key: String) -> String {
        if let p = prefix {
            return "\(p)[\(key)]"
        } else {
            return key
        }
    }
}

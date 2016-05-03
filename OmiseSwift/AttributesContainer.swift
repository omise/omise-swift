import Foundation

public typealias JSONAttributes = [String: NSObject]

public protocol AttributesContainer: class {
    var attributes: JSONAttributes { get set }
    var children: [String: AttributesContainer] { get set }
    
    init(attributes: JSONAttributes)
}

// convenience getters/setters
public extension AttributesContainer {
    func get<TConv: Converter>(key: String, _ converter: TConv.Type) -> TConv.Target? {
        return TConv.convertFromAttribute(self.attributes[key])
    }
    
    func set<TConv: Converter>(key: String, _ converter: TConv.Type, toValue value: TConv.Target?) {
        self.attributes[key] = TConv.convertToAttribute(value)
    }
    
    // TODO: Cache lists
    func getList<TItem: AttributesContainer>(key: String, _ itemType: TItem.Type) -> [TItem] {
        let items = self.attributes[key] as? [JSONAttributes] ?? []
        return items.map({ (attributes) -> TItem in TItem(attributes: attributes) })
    }
    
    func setList<TItem: AttributesContainer>(key: String, _ itemType: TItem.Type, toValue value: [TItem]) {
        attributes[key] = value.map({ (model) -> JSONAttributes in model.attributes })
    }
    
    func getChild<TChild: AttributesContainer>(key: String, _ childType: TChild.Type) -> TChild? {
        if let child = children[key] as? TChild {
            return child
        }
        
        let child = TChild(attributes: (attributes[key] as? JSONAttributes) ?? [:])
        dump(String(TChild), name: "child type")
        dump(children, name: "before")
        children[key] = child
        dump(children, name: "after")
        return child
    }
    
    func setChild<TChild: OmiseObject>(key: String, _ childType: TChild.Type, toValue child: TChild?) {
        children[key] = child
    }
}

// attributes normalization
public extension AttributesContainer {
    var normalizedAttributes: JSONAttributes {
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

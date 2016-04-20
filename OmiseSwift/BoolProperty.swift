import Foundation

class BoolProperty: Property {
    typealias TargetType = Bool
    
    static func get(model: Model, key: String) -> TargetType? {
        return model.attributes[key] as? Bool
    }
    
    static func set(model: Model, key: String, toValue value: TargetType?) {
        if let v = value {
            model.attributes[key] = NSNumber(bool: v)
        } else {
            model.attributes[key] = nil
        }
    }
}

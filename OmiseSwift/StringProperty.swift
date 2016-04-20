import Foundation

class StringProperty: Property {
    typealias TargetType = String
    
    static func get(model: Model, key: String) -> TargetType? {
        return model.attributes[key] as? String
    }
    
    static func set(model: Model, key: String, toValue value: TargetType?) {
        if let v = value {
            model.attributes[key] = v as NSString
        } else {
            model.attributes[key] = nil
        }
    }
}

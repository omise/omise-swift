import Foundation

class Int64Property: Property {
    typealias TargetType = Int64
    
    static func get(model: Model, key: String) -> TargetType? {
        guard let number = model.attributes[key] as? NSNumber else {
            return nil
        }
        
        return number.longLongValue
    }
    
    static func set(model: Model, key: String, toValue value: TargetType?) {
        if let v = value {
            model.attributes[key] = NSNumber(longLong: v)
        } else {
            model.attributes[key] = nil
        }
    }
}

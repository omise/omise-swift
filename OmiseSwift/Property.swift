import Foundation

protocol Property {
    associatedtype TargetType
    
    static func get(model: Model, key: String) -> TargetType?
    static func set(model: Model, key: String, toValue value: TargetType?)
}

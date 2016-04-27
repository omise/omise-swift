import Foundation

public typealias JSONAttributes = [String: NSObject]

public protocol AttributesContainer: class {
    var attributes: JSONAttributes { get set }
}

public extension AttributesContainer {
    func get<TConv: Converter>(key: String, _ converter: TConv.Type) -> TConv.Target? {
        return TConv.convertFromAttribute(self.attributes[key])
    }
    
    func set<TConv: Converter>(key: String, _ converter: TConv.Type, toValue value: TConv.Target?) {
        self.attributes[key] = TConv.convertToAttribute(value)
    }
}

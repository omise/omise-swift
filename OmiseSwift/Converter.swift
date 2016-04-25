import Foundation

protocol Converter {
    associatedtype TargetType
    
    static func convertFromAttribute(value: NSObject?) -> TargetType?
    static func convertToAttribute(value: TargetType?) -> NSObject?
}

extension OmiseObject {
    func get<TConv: Converter>(key: String, _ converter: TConv.Type) -> TConv.TargetType? {
        return TConv.convertFromAttribute(self.attributes[key])
    }
    
    func set<TConv: Converter>(key: String, _ converter: TConv.Type, toValue value: TConv.TargetType?) {
        self.attributes[key] = TConv.convertToAttribute(value)
    }
}


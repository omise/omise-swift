import Foundation

public protocol Converter {
    associatedtype Target
    
    static func convertFromAttribute(value: NSObject?) -> Target?
    static func convertToAttribute(value: Target?) -> NSObject?
}

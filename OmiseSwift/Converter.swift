import Foundation

public protocol Converter {
    associatedtype Target
    
    static func convert(fromAttribute value: Any?) -> Target?
    static func convert(fromValue value: Target?) -> Any?
}

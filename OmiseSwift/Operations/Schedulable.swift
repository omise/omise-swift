import Foundation

public protocol SchedulingParameter: APIJSONQuery {}

public protocol Schedulable: OmiseIdentifiableObject, OmiseCreatedObject {
    associatedtype ScheduleData: OmiseIdentifiableObject, OmiseCreatedObject, OmiseLiveModeObject
    associatedtype Parameter: SchedulingParameter
    static func isValidParameterKey(_ key: String) -> Bool
    static var parameterKey: String { get }
}

extension Schedulable {
    public static var parameterKey: String {
        return String(describing: self).lowercased()
    }
    
    public static func isValidParameterKey(_ key: String) -> Bool {
        return parameterKey == key
    }
}

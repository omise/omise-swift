import Foundation
import EventKit


public struct Schedule<Data: Schedulable>: OmiseResourceObject {
    public enum Status: Equatable {
        case active
        case expiring
        case expired
        case deleted
        case suspended
    }
    
    
    public static var resourceInfo: ResourceInfo {
        return ResourceInfo(path: "/schedules")
    }
    
    public let object: String
    public let location: String
    
    public let id: String
    public let isLive: Bool
    public let createdDate: Date
    
    public let status: Status
    public let isDeleted: Bool
    
    public let every: Int
    public let period: Period
    
    public let startDate: DateComponents
    public let endDate: DateComponents
    
    public let occurrences: ListProperty<Occurrence<Data>>
    public let nextOccurrenceDates: [DateComponents]
    
    public let parameter: Data.Parameter
}

public protocol SchedulingParameter {
    init?(JSON: Any)
}

public protocol Schedulable: OmiseIdentifiableObject {
    associatedtype Parameter: SchedulingParameter
    static var parameterKey: String { get }
}

extension Schedulable {
    public static var parameterKey: String {
        return String(describing: self).lowercased()
    }
}

extension Schedule {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Schedule.parseOmiseResource(JSON: json) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate) = omiseObjectProperties
        
        guard
            let status = json["status"].flatMap(Schedule.Status.init(JSON:)),
            let period = Period(JSON: json),
            let isDeleted = json["deleted"] as? Bool,
            let every = json["every"] as? Int,
            let startDate = json["start_date"].flatMap(DateComponentsConverter.convert),
            let endDate = json["end_date"].flatMap(DateComponentsConverter.convert),
            let occurrences = json["occurrences"].flatMap(ListProperty<Occurrence<Data>>.init(JSON:)),
            let nextOccurrences = (json["next_occurrences"] as? [Any]).map({ $0.flatMap(DateComponentsConverter.convert) }),
            let parameter = json[Data.parameterKey].flatMap(Data.Parameter.init(JSON:)) else {
                return nil
        }
        
        self.status = status
        self.isDeleted = isDeleted
        self.period = period
        self.every = every
        self.startDate = startDate
        self.endDate = endDate
        self.occurrences = occurrences
        self.nextOccurrenceDates = nextOccurrences
        self.parameter = parameter
    }
}

extension Schedule.Status {
    init?(JSON json: Any) {
        let status = (json as? String) ?? (json as? [String: Any])?["status"] as? String
        switch status {
        case "active"?:
            self = .active
        case "expiring"?:
            self = .expiring
        case "expired"?:
            self = .expired
        case "deleted"?:
            self = .deleted
        case "suspended"?:
            self = .suspended
        default:
            return nil
        }
    }
}


extension Schedule: Listable {}
extension Schedule: Retrievable {}



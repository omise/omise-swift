import Foundation


public enum WeekDay {
    case sunday
    case monday
}

public struct Schedule: OmiseResourceObject {
    public enum Status {
        case active
        case expiring
        case expired
        case deleted
        case suspended
    }
    
    public enum Period {
        case daily
        case weekly
        case monthly
    }
    
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/schedules")
    
    public let object: String
    public let location: String
    
    public let id: String
    public let isLive: Bool
    public let createdDate: Date
    
    public let status: Status
    public let isDeleted: Bool
    
    public let every: Int
    public let period: Period
    
    public let startDate: Date
    public let endDate: Date
    
    public let occurrences: ListProperty<Occurrence>
    public let nextOccurrences: [Date]
    
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
            let period = json["period"].flatMap(Schedule.Period.init(JSON:)),
            let isDeleted = json["deleted"] as? Bool,
            let every = json["every"] as? Int,
            let startDate = json["start_date"].flatMap(DateConverter.convert),
            let endDate = json["end_date"].flatMap(DateConverter.convert),
            let occurrences = json["occurrences"].flatMap(ListProperty<Occurrence>.init(JSON:)),
            let nextOccurrences = (json["next_occurrences"] as? [Any]).map({ $0.flatMap(DateConverter.convert) }) else {
                return nil
        }
        self.status = status
        self.isDeleted = isDeleted
        self.period = period
        self.every = every
        self.startDate = startDate
        self.endDate = endDate
        self.occurrences = occurrences
        self.nextOccurrences = nextOccurrences
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


extension Schedule.Period {
    init?(JSON json: Any) {
        let status = (json as? String) ?? (json as? [String: Any])?["period"] as? String
        switch status {
        case "day"?:
            self = .daily
        case "week"?:
            self = .weekly
        case "month"?:
            self = .monthly
        default:
            return nil
        }
    }
}



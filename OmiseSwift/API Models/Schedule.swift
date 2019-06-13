import Foundation


public struct Schedule<Data: Schedulable>: OmiseResourceObject, Equatable {
    public enum Status: Equatable {
        case running
        case expiring
        case expired
        case deleted
        case suspended
        case unknown(String)
    }
    
    public static var idPrefix: String {
        return "schd"
    }
    public static var resourcePath: String {
        return "/schedules"
    }
    
    public let object: String
    public let location: String
    
    public let id: DataID<Schedule<Data>>
    public let isLiveMode: Bool
    public let isDeleted: Bool
    public let createdDate: Date
    
    public let status: Status
    public let isActive: Bool
    
    public let every: Int
    public let period: Period
    
    public let startOnDateComponents: DateComponents
    public let endOnDateComponents: DateComponents
    
    public let occurrences: ListProperty<Occurrence<Data>>
    public let nextOccurrencesOnDateComponents: [DateComponents]
    
    public let scheduleData: Data.ScheduleData
}

extension Schedule {
    fileprivate enum CodingKeys: CodingKey {
        case object
        case location
        case id
        case isLiveMode
        case isDeleted
        case createdDate
        
        case status
        case isActive
        
        case every
        case period
        case startDate
        case endDate
        case occurrences
        case nextOccurrenceDates
        case parameter(String)
        
        public var stringValue: String {
            switch self {
            case .object:
                return "object"
            case .location:
                return "location"
            case .id:
                return "id"
            case .isLiveMode:
                return "livemode"
            case .isDeleted:
                return "deleted"
            case .createdDate:
                return "created_at"
                
            case .status:
                return "status"
            case .isActive:
                return "active"
            case .every:
                return "every"
            case .period:
                return "period"
            case .startDate:
                return "start_on"
            case .endDate:
                return "end_on"
            case .occurrences:
                return "occurrences"
            case .nextOccurrenceDates:
                return "next_occurrences_on"
            case .parameter(let parameterKey):
                return parameterKey
            }
        }
        
        init?(stringValue: String) {
            switch stringValue {
            case "object":
                self = .object
            case "location":
                self = .location
            case "id":
                self = .id
            case "livemode":
                self = .isLiveMode
            case "deleted":
                self = .isDeleted
            case "created_at":
                self = .createdDate
                
            case "status":
                self = .status
            case "active":
                self = .isActive
            case "every":
                self = .every
            case "period":
                self = .period
            case "start_on":
                self = .startDate
            case "end_on":
                self = .endDate
            case "occurrences":
                self = .occurrences
            case "next_occurrences_on":
                self = .nextOccurrenceDates
            case let value where Data.isValidParameterKey(value):
                self = .parameter(value)
            default:
                return nil
            }
        }
        
        init?(intValue: Int) {
            return nil
        }
        
        public var intValue: Int? {
            return nil
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        object = try container.decode(String.self, forKey: .object)
        location = try container.decode(String.self, forKey: .location)
        id = try container.decode(DataID<Schedule<Data>>.self, forKey: .id)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        isLiveMode = try container.decode(Bool.self, forKey: .isLiveMode)
        isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        
        status = try container.decode(Schedule.Status.self, forKey: .status)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        
        every = try container.decode(Int.self, forKey: .every)
        period = try Period.init(from: decoder)
        
        startOnDateComponents = try container.decode(DateComponents.self, forKey: .startDate)
        endOnDateComponents = try container.decode(DateComponents.self, forKey: .endDate)
        
        occurrences = try container.decode(ListProperty<Occurrence<Data>>.self, forKey: .occurrences)
        nextOccurrencesOnDateComponents = try container.decode(Array<DateComponents>.self, forKey: .nextOccurrenceDates)
        
        let parameterKey = container.allKeys.first(where: { (key) -> Bool in
            if case .parameter = key {
                return true
            } else {
                return false
            }
        })
        if let parameterKey = parameterKey {
            scheduleData = try container.decode(Data.ScheduleData.self, forKey: parameterKey)
        } else {
            throw DecodingError.keyNotFound(
                Schedule<Data>.CodingKeys.parameter("parameter"),
                DecodingError.Context(codingPath: container.codingPath, debugDescription: "Missing scheduling parameter"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(object, forKey: .object)
        try container.encode(location, forKey: .location)
        try container.encode(id, forKey: .id)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(isDeleted, forKey: .isDeleted)
        try container.encode(isLiveMode, forKey: .isLiveMode)
        try container.encode(status, forKey: .status)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(every, forKey: .every)
        
        try period.encode(to: encoder)
        
        try container.encode(startOnDateComponents, forKey: .startDate)
        try container.encode(endOnDateComponents, forKey: .endDate)
        try container.encode(occurrences, forKey: .occurrences)
        try container.encode(nextOccurrencesOnDateComponents, forKey: .nextOccurrenceDates)
        try container.encode(scheduleData, forKey: .parameter(Data.parameterKey))
    }
}

extension Calendar {
    public static let scheduleAPICalendar: Calendar = {
        return Calendar(identifier: .gregorian)
    }()
}


extension Schedule.Status: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let status = try container.decode(String.self)
        switch status {
        case "running":
            self = .running
        case "expiring":
            self = .expiring
        case "expired":
            self = .expired
        case "deleted":
            self = .deleted
        case "suspended":
            self = .suspended
        case let value:
            self = .unknown(value)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let status: String
        switch self {
        case .running:
            status = "running"
        case .expiring:
            status = "expiring"
        case .expired:
            status = "expired"
        case .deleted:
            status = "deleted"
        case .suspended:
            status = "suspended"
        case .unknown(let value):
            status = value
        }
        try container.encode(status)
    }
}


extension Schedule: OmiseAPIPrimaryObject {}
extension Schedule: Listable {}
extension Schedule: Retrievable {}
extension Schedule: Destroyable {}


public struct ScheduleParams<Data: Schedulable>: APIJSONQuery {
    public let every: Int
    public let period: Period
    public let endDate: DateComponents
    public let startDate: DateComponents?
    
    public let scheduleData: Data.Parameter
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Schedule<Data>.CodingKeys.self)
        
        try container.encode(every, forKey: .every)
        try container.encode(endDate, forKey: .endDate)
        try container.encodeIfPresent(startDate, forKey: .startDate)
        
        try period.encode(to: encoder)
        
        try container.encode(scheduleData, forKey: .parameter(Data.parameterKey))
    }
}

extension Schedule : Creatable where Data : Creatable & Schedulable {
    public typealias CreateParams = ScheduleParams<Data>
}




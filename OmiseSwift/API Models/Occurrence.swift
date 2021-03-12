import Foundation

public struct Occurrence<Data: Schedulable>: OmiseResourceObject, Equatable {
    
    public enum Status: Equatable {
        case skipped(String)
        case failed(String)
        case successful
        case unknown(status: String, message: String?)
    }
    
    public static var idPrefix: String {
        return "occu"
    }
    public static var resourcePath: String {
        return "/occurrences"
    }
    
    public let object: String
    public let location: String
    
    public let id: DataID<Occurrence>
    public let isLiveMode: Bool
    public let createdDate: Date
    
    public let schedule: DetailProperty<Schedule<Data>>
    public let scheduledOnDateComponents: DateComponents
    
    public let retryOnDateComponents: DateComponents?
    public let processedDate: Date
    
    public let status: Status
    public let result: DetailProperty<Data>
}

extension Occurrence {
    
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case createdDate = "created_at"
        case isLiveMode = "livemode"
        case schedule
        case status
        case message
        case scheduleDate = "scheduled_on"
        case processedDate = "processed_at"
        case result
        case retryDate = "retry_on"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        object = try container.decode(String.self, forKey: .object)
        location = try container.decode(String.self, forKey: .location)
        id = try container.decode(DataID<Occurrence<Data>>.self, forKey: .id)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        isLiveMode = try container.decode(Bool.self, forKey: .isLiveMode)
        schedule = try container.decode(DetailProperty<Schedule<Data>>.self, forKey: .schedule)
        scheduledOnDateComponents = try container.decode(DateComponents.self, forKey: .scheduleDate)
        processedDate = try container.decode(Date.self, forKey: .processedDate)
        result = try container.decode(DetailProperty<Data>.self, forKey: .result)
        
        retryOnDateComponents = try container.decodeIfPresent(DateComponents.self, forKey: .retryDate)
        
        let status = try container.decode(String.self, forKey: .status)
        let message = try container.decodeIfPresent(String.self, forKey: .message)
        
        switch (status, message) {
        case ("successful", nil):
            self.status = .successful
        case ("failed", let message?):
            self.status = .failed(message)
        case ("skipped", let message?):
            self.status = .skipped(message)
        case (let statusValue, let message):
            self.status = .unknown(status: statusValue, message: message)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(object, forKey: .object)
        try container.encode(location, forKey: .location)
        try container.encode(id, forKey: .id)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(isLiveMode, forKey: .isLiveMode)
        try container.encode(schedule, forKey: .schedule)
        try container.encode(scheduledOnDateComponents, forKey: .scheduleDate)
        try container.encode(processedDate, forKey: .processedDate)
        
        try container.encode(result, forKey: .result)
        try container.encodeIfPresent(retryOnDateComponents, forKey: .retryDate)
        
        switch status {
        case .successful:
            try container.encode("successful", forKey: .status)
        case .skipped(let skippedMessage):
            try container.encode("skipped", forKey: .status)
            try container.encode(skippedMessage, forKey: .message)
        case .failed(let failureMessage):
            try container.encode("failed", forKey: .status)
            try container.encode(failureMessage, forKey: .message)
        case .unknown(status: let name, message: let message):
            try container.encode(name, forKey: .status)
            try container.encodeIfPresent(message, forKey: .message)
        }
    }
}

extension Occurrence: OmiseAPIChildObject {
    public typealias Parent = Schedule<Data>
}
extension Occurrence: Listable {}
extension Occurrence: Retrievable {}

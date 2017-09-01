import Foundation


public struct Occurrence<Data: Schedulable>: OmiseResourceObject {
    
    public enum Status {
        case skipped(String)
        case failed(String)
        case successful
    }
    
    public static var resourceInfo: ResourceInfo {
        return ResourceInfo(parentType: Schedule<Data>.self, path: "/occurrences")
    }
    
    public let object: String
    public let location: String
    
    public let id: String
    public let isLive: Bool
    public let createdDate: Date
    
    public let schedule: DetailProperty<Schedule<Data>>
    public let scheduleDate: DateComponents
    
    public let retryDate: DateComponents?
    public let processedDate: Date
    
    public let status: Status
    public let result: DetailProperty<Data>
}


extension Occurrence {
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case createdDate = "created"
        case isLive = "livemode"
        case schedule
        case status
        case message
        case scheduleDate = "schedule_date"
        case processedDate = "processed_at"
        case result
        case retryDate = "retry_date"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        object = try container.decode(String.self, forKey: .object)
        location = try container.decode(String.self, forKey: .location)
        id = try container.decode(String.self, forKey: .id)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        isLive = try container.decode(Bool.self, forKey: .isLive)
        schedule = try container.decode(DetailProperty<Schedule<Data>>.self, forKey: .schedule)
        scheduleDate = try DateComponentsConverter.decode(using: container, forKey: .scheduleDate)
        processedDate = try container.decode(Date.self, forKey: .processedDate)
        result = try container.decode(DetailProperty<Data>.self, forKey: .result)
        
        retryDate = try DateComponentsConverter.decodeIfPresent(using: container, forKey: .retryDate)
        
        let status = try container.decode(String.self, forKey: .status)
        let message = try container.decodeIfPresent(String.self, forKey: .message)
        
        switch (status, message) {
        case ("successful", nil):
            self.status = .successful
        case ("failed", let message?):
            self.status = .failed(message)
        case ("skipped", let message?):
            self.status = .skipped(message)
        default:
            let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid Occurrence status")
            throw DecodingError.dataCorrupted(context)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(object, forKey: .object)
        try container.encode(location, forKey: .location)
        try container.encode(id, forKey: .id)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(isLive, forKey: .isLive)
        try container.encode(schedule, forKey: .schedule)
        try container.encode(scheduleDate, forKey: .scheduleDate)
        try container.encode(processedDate, forKey: .processedDate)
        
        try container.encode(result, forKey: .result)
        try container.encodeIfPresent(DateComponentsConverter.convert(fromValue: retryDate) as? String, forKey: .retryDate)
        
        switch status {
        case .successful:
            try container.encode("successful", forKey: .status)
        case .skipped(let skippedMessage):
            try container.encode("skipped", forKey: .status)
            try container.encode(skippedMessage, forKey: .message)
        case .failed(let failureMessage):
            try container.encode("failed", forKey: .status)
            try container.encode(failureMessage, forKey: .message)
        }
    }
}


extension Occurrence.Status: Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Occurrence<Data>.Status, rhs: Occurrence<Data>.Status) -> Bool {
        switch (lhs, rhs) {
        case (.successful, .successful):
            return true
        case (.failed(let lhsMessage), .failed(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.skipped(let lhsMessage), .skipped(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

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
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Occurrence<Data>.parseOmiseResource(JSON: json) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate) = omiseObjectProperties
        
        guard
            let status = Occurrence.Status(JSON: json),
            let schedule = json["schedule"].flatMap(DetailProperty<Schedule<Data>>.init(JSON:)),
            let scheduleDate = json["schedule_date"].flatMap(DateComponentsConverter.convert(fromAttribute:)),
            let processedDate = json["processed_at"].flatMap(DateConverter.convert(fromAttribute:)),
            let result = json["result"].flatMap(DetailProperty<Data>.init(JSON:)) else {
                return nil
        }
        
        self.status = status
        self.schedule = schedule
        self.scheduleDate = scheduleDate
        self.processedDate = processedDate
        self.result = result
        self.retryDate = json["retry_date"].flatMap(DateComponentsConverter.convert(fromAttribute:))
    }
    
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case createdDate = "created_date"
        case isLive = "livemode"
        case schedule
        case status
        case message
        case scheduleDate = "schedule_at"
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
        scheduleDate = try container.decode(DateComponents.self, forKey: .scheduleDate)
        processedDate = try container.decode(Date.self, forKey: .processedDate)
        result = try container.decode(DetailProperty<Data>.self, forKey: .result)
        
        retryDate = try container.decodeIfPresent(DateComponents.self, forKey: .retryDate)
        
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

    init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let status = json["status"] as? String else {
                return nil
        }
        
        let message = json["message"] as? String
        
        switch (status, message) {
        case ("successful", nil):
            self = .successful
        case ("failed", let message?):
            self = .failed(message)
        case ("skipped", let message?):
            self = .skipped(message)
        default:
            return nil
        }
    }
}

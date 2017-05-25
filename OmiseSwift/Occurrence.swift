import Foundation


public struct Occurrence<Data: Schedulable>: OmiseLocatableObject, OmiseIdentifiableObject {
    
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
            let omiseObjectProperties = Occurrence<Data>.parseOmiseProperties(JSON: json) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.createdDate) = omiseObjectProperties
        
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

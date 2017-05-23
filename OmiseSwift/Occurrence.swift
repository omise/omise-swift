import Foundation


public struct Occurrence: OmiseResourceObject {
    
    public enum Status {
        case skipped(String)
        case failed(String)
        case successful
    }
    
    public static let resourceInfo: ResourceInfo = ResourceInfo(parentType: Schedule.self, path: "/occurrences")
    
    public let object: String
    public let location: String
    
    public let id: String
    public let isLive: Bool
    public let createdDate: Date
    
    
    public let schedule: DetailProperty<Schedule>
    public let scheduleDate: Date
    
    public let retryDate: Date
    public let processedDate: Date
    
    public let status: Status
    
    
}


extension Occurrence {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Occurrence.parseOmiseResource(JSON: json) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate) = omiseObjectProperties
        
        guard
        let status = Occurrence.Status(JSON: json),
        let schedule = json["schedule"].flatMap(DetailProperty<Schedule>.init(JSON:)),
        let scheduleDate = json["schedule_date"].flatMap(DateConverter.convert(fromAttribute:)),
        let retryDate = json["schedule_date"].flatMap(DateConverter.convert(fromAttribute:)),
            let processedDate = json["processed_at"].flatMap(DateConverter.convert(fromAttribute:)) else {
                return nil
        }
        
        self.status = status
        self.schedule = schedule
        self.scheduleDate = scheduleDate
        self.retryDate = retryDate
        self.processedDate = processedDate
    }
}


extension Occurrence.Status {
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

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
    public let scheduleDate: Date
    
    public let retryDate: Date
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
            let scheduleDate = json["schedule_date"].flatMap(DateConverter.convert(fromAttribute:)),
            let retryDate = json["schedule_date"].flatMap(DateConverter.convert(fromAttribute:)),
            let processedDate = json["processed_at"].flatMap(DateConverter.convert(fromAttribute:)),
            let result = json["result"].flatMap(DetailProperty<Data>.init(JSON:)) else {
                return nil
        }
        
        self.status = status
        self.schedule = schedule
        self.scheduleDate = scheduleDate
        self.retryDate = retryDate
        self.processedDate = processedDate
        self.result = result
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

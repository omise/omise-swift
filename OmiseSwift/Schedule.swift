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
    
    public let every: Int
    public let period: Period
    
    public let startDate: DateComponents
    public let endDate: DateComponents
    
    public let occurrences: ListProperty<Occurrence<Data>>
    public let nextOccurrenceDates: [DateComponents]
    
    public let parameter: Data.Parameter
}

extension Calendar {
    public static var scheduleAPICalendar: Calendar {
        return Calendar(identifier: .gregorian)
    }
}

public protocol SchedulingParameter {
    init?(JSON: Any)
}

public protocol Schedulable: OmiseIdentifiableObject, OmiseCreatableObject {
    associatedtype Parameter: SchedulingParameter
    static func preferredParameterKey(from: [String]) -> String?
    static var parameterKey: String { get }
}

public protocol APISchedulable: Schedulable {
    associatedtype ScheduleDataParams: APIJSONQuery
}

extension Schedulable {
    public static var parameterKey: String {
        return String(describing: self).lowercased()
    }
    
    public static func preferredParameterKey(from: [String]) -> String? {
        guard from.contains(self.parameterKey) else {
            return nil
        }
        return parameterKey
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
            let every = json["every"] as? Int,
            let startDate = json["start_date"].flatMap(DateComponentsConverter.convert),
            let endDate = json["end_date"].flatMap(DateComponentsConverter.convert),
            let occurrences = json["occurrences"].flatMap(ListProperty<Occurrence<Data>>.init(JSON:)),
            let nextOccurrences = (json["next_occurrence_dates"] as? [Any]).map({ $0.flatMap(DateComponentsConverter.convert) }),
            let parameter = Data.preferredParameterKey(from: Array(json.keys)).flatMap({ json[$0] }).flatMap(Data.Parameter.init(JSON:)) else {
                return nil
        }
        
        self.status = status
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


public struct AnySchedulable: Schedulable, OmiseIdentifiableObject, OmiseCreatableObject {
    public enum AnySchedulingParameter: SchedulingParameter {
        case charge(ChargeSchedulingParameter)
        case transfer(TransferSchedulingParameter)
        case other(json: [String: Any])
        
        public init?(JSON json: Any) {
            guard let json = json as? [String: Any] else {
                return nil
            }
            
            if let chargeParameter = ChargeSchedulingParameter(JSON: json) {
                self = .charge(chargeParameter)
            } else if let transferParameter = TransferSchedulingParameter(JSON: json){
                self = .transfer(transferParameter)
            } else {
                self = .other(json: json)
            }
        }
    }
    
    public typealias Parameter = AnySchedulingParameter
    public let id: String
    public let createdDate: Date
    public let object: String
    
    public let json: [String: Any]
    
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseProperties = AnySchedulable.parseIdentifiableProperties(JSON: json) else {
                return nil
        }
        
        (self.object, self.id, self.createdDate) = omiseProperties
        self.json = json
    }
    
    public static func preferredParameterKey(from: [String]) -> String? {
        if from.contains(Charge.parameterKey) {
            return Charge.parameterKey
        } else if from.contains(Transfer.parameterKey) {
            return Transfer.parameterKey
        } else {
            return nil
        }
    }
}


extension Schedule: Listable {}
extension Schedule: Retrievable {}


public struct ScheduleParams<Data: APISchedulable>: APIJSONQuery {
    public let every: Int
    public let period: Period
    public let endDate: DateComponents
    public let startDate: DateComponents?
    
    public let scheduleData: Data.ScheduleDataParams
    
    public var json: JSONAttributes {
        let scheduleJSON = Dictionary.makeFlattenDictionaryFrom([
            "end_date": DateComponentsConverter.convert(fromValue: endDate),
            "start_date": startDate.flatMap(DateComponentsConverter.convert(fromValue:)),
            "every": every,
            ])
        let periodJSON = period.json
        let scheduleDataJSON = ["charge": scheduleData.json] as [String: Any]
        
        return scheduleJSON
            .merging(periodJSON)
            .merging(scheduleDataJSON)
    }
}

/*
 // Make Schedule conforms to `Creatable` protocol when Conditional Conformances is ready in Swift.
 // For now we need to make this workaround to avoid the compiler error in Swift
extension Schedule: Creatable {
    public typealias CreateParams = ScheduleParams<Data>
}
*/

extension Schedule where Data: APISchedulable {
    public typealias CreateEndpoint = APIEndpoint<Schedule>
    public typealias CreateRequest = APIRequest<Schedule>
    
    public static func createEndpointWith(parent: OmiseResourceObject?, params: ScheduleParams<Data>) -> CreateEndpoint {
        return CreateEndpoint(
            pathComponents: Schedule.makeResourcePathsWithParent(parent),
            parameter: .post(params)
        )
    }
    
    public static func create(using client: APIClient, parent: OmiseResourceObject? = nil, params: ScheduleParams<Data>, callback: @escaping CreateRequest.Callback) -> CreateRequest? {
        guard Schedule.verifyParent(parent) else {
            return nil
        }
        
        let endpoint = self.createEndpointWith(parent: parent, params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}





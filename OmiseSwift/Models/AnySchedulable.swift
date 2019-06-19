import Foundation


public struct AnySchedulable: Schedulable {
    public typealias ScheduleData = AnyScheduleData
    public typealias Parameter = AnySchedulingParameter
    
    public static let idPrefix: String = ""
    
    public let id: DataID<AnySchedulable>
    public let createdDate: Date
    public let object: String
    
    public let json: [String: Any]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdDate = "created_at"
        case object
        case isLiveMode = "livemode"
    }
    
    public init(from decoder: Decoder) throws {
        let json = try decoder.decode(as: Dictionary<String, Any>.self)
        
        guard let object = json[CodingKeys.object.stringValue] as? String else {
            let context = DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Missing object value in Schedule")
            throw DecodingError.keyNotFound(CodingKeys.object, context)
        }
        
        guard let id = (json[CodingKeys.id.stringValue] as? String)
            .flatMap(DataID<AnySchedulable>.init(idString:)) else {
                let context = DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Missing object value in Schedule")
                throw DecodingError.keyNotFound(CodingKeys.id, context)
        }
        guard let createdDate = (json[CodingKeys.createdDate.stringValue] as? String).flatMap({
            ISO8601DateFormatter().date(from: $0)
        }) else {
            let context = DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Missing object value in Schedule")
            throw DecodingError.keyNotFound(CodingKeys.createdDate, context)
        }
        
        (self.object, self.id, self.createdDate) = (object, id, createdDate)
        self.json = json
    }
    
    public func encode(to encoder: Encoder) throws {
        var jsonValue = json
        jsonValue[CodingKeys.id.stringValue] = id
        jsonValue[CodingKeys.createdDate.stringValue] = createdDate
        jsonValue[CodingKeys.object.stringValue] = object
        try encoder.encode(jsonValue)
    }
    
    public static func validate(id: String) -> Bool {
        return Charge.validate(id: id) || Transfer.validate(id: id)
    }
    
    public static func isValidParameterKey(_ key: String) -> Bool {
        return key == Charge.parameterKey || key == Transfer.parameterKey
    }
    
    public struct AnyScheduleData: OmiseIdentifiableObject, OmiseLiveModeObject, OmiseCreatedObject {
        public static let idPrefix: String = "r"
        
        public static func validate(id: String) -> Bool {
            return ChargeSchedule.validate(id: id) || TransferSchedule.validate(id: id)
        }
        
        public let id: DataID<AnyScheduleData>
        public let createdDate: Date
        public let object: String
        public let isLiveMode: Bool
        
        public let json: [String: Any]
        
        public init(from decoder: Decoder) throws {
            let json = try decoder.decode(as: Dictionary<String, Any>.self)
            
            guard let object = json[CodingKeys.object.stringValue] as? String else {
                let context = DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Missing object value in Schedule")
                throw DecodingError.keyNotFound(CodingKeys.object, context)
            }
            
            guard let id = (json[CodingKeys.id.stringValue] as? String)
                .flatMap(DataID<AnyScheduleData>.init(idString:)) else {
                    let context = DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Missing object value in Schedule")
                    throw DecodingError.keyNotFound(CodingKeys.id, context)
            }
            guard let createdDate = (json[CodingKeys.createdDate.stringValue] as? String).flatMap({
                ISO8601DateFormatter().date(from: $0)
            }) else {
                let context = DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Missing object value in Schedule")
                throw DecodingError.keyNotFound(CodingKeys.createdDate, context)
            }
            guard let isLiveMode = json[CodingKeys.isLiveMode.stringValue] as? Bool else {
                let context = DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Missing object value in Schedule")
                throw DecodingError.keyNotFound(CodingKeys.isLiveMode, context)
            }
            
            (self.object, self.id, self.createdDate, self.isLiveMode) = (object, id, createdDate, isLiveMode)
            self.json = json
        }
        
        public func encode(to encoder: Encoder) throws {
            var jsonValue = json
            jsonValue[CodingKeys.id.stringValue] = id
            jsonValue[CodingKeys.createdDate.stringValue] = createdDate
            jsonValue[CodingKeys.object.stringValue] = object
            jsonValue[CodingKeys.isLiveMode.stringValue] = isLiveMode
            try encoder.encode(jsonValue)
        }
    }
    
    public enum AnySchedulingParameter: SchedulingParameter, APIJSONQuery {
        case charge(ChargeSchedulingParameter)
        case transfer(TransferSchedulingParameter)
        case other(json: [String: Any])
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .charge(let parameter):
                try container.encode(parameter)
            case .transfer(let parameter):
                try container.encode(parameter)
            case .other(json: let parameter):
                try encoder.encode(parameter)
            }
        }
    }
}


import Foundation

public enum DisputeStatus: String {
    case open
    case pending
    case won
    case lost
    case closed
}


public struct Dispute: OmiseResourceObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/disputes")
    
    public let object: String
    public let location: String
    
    public let id: String
    public let isLive: Bool
    public var createdDate: Date
    public let isDeleted: Bool
    
    public let value: Value
    public var status: DisputeStatus
    public let message: String
    public let charge: DetailProperty<Charge>
}


extension Dispute {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Charge.parseOmiseResource(JSON: json) else {
                return nil
        }
        
        guard let value = Value(JSON: json), let status = json["status"].flatMap(EnumConverter<DisputeStatus>.convert(fromAttribute:)),
        let message = json["message"] as? String,
            let charge = json["charge"].flatMap(DetailProperty<Charge>.init(JSON:)) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate, self.isDeleted) = omiseObjectProperties
        self.value = value
        self.status = status
        self.message = message
        self.charge = charge
    }
}


public enum DisputeStatusQuery: String {
    case open
    case pending
    case closed
}


public struct DisputeParams: APIParams {
    public var message: String?
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "message": message,
            ])
    }
}

public struct DisputeFilterParams: OmiseFilterParams {
    public var created: DateComponents?
    public var cardLastDigits: LastDigits?
    public var reasonCode: String?
    public var status: DisputeStatus?
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "created": DateComponentsConverter.convert(fromValue: created),
            "card_last_digits": cardLastDigits?.lastDigits,
            "reason_code": reasonCode,
            "status": status?.rawValue
            ])
    }
}

extension Dispute: Listable { }
extension Dispute: Retrievable { }

extension Dispute: Updatable {
    public typealias UpdateParams = DisputeParams
}

extension Dispute: Searchable {
    public typealias FilterParams = DisputeFilterParams
}


extension Dispute {
    public static func list(using client: APIClient, state: DisputeStatusQuery, params: ListParams? = nil, callback: @escaping Dispute.ListRequest.Callback) -> Dispute.ListRequest? {
        let endpoint = ListEndpoint(
            endpoint: resourceInfo.endpoint,
            method: "GET",
            pathComponents: [resourceInfo.path, state.rawValue],
            params: nil
        )
        
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

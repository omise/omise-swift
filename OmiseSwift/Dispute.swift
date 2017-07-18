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
    
    public let value: Value
    public var status: DisputeStatus
    public let reasonMessage: String
    public var responseMessage: String?
    public let charge: DetailProperty<Charge>
    
    public let documents: ListProperty<Document>
}


extension Dispute {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Dispute.parseOmiseResource(JSON: json) else {
                return nil
        }
        
        guard let value = Value(JSON: json),
            let status = json["status"].flatMap(EnumConverter<DisputeStatus>.convert(fromAttribute:)),
            let reasonMessage = json["reason_message"] as? String,
            let charge = json["charge"].flatMap(DetailProperty<Charge>.init(JSON:)),
            let documents = json["documents"].flatMap(ListProperty<Document>.init(JSON:)) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate) = omiseObjectProperties
        self.value = value
        self.status = status
        self.reasonMessage = reasonMessage
        self.responseMessage = json["message"] as? String
        self.charge = charge
        self.documents = documents
    }
}


public enum DisputeStatusQuery: String {
    case open
    case pending
    case closed
}


public struct DisputeParams: APIJSONQuery {
    public var message: String?
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "message": message,
            ])
    }
    
    public init(message: String?) {
        self.message = message
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
    
    public init(status: DisputeStatus? = nil, cardLastDigits: LastDigits? = nil,
                created: DateComponents? = nil, reasonCode: String? = nil) {
        self.status = status
        self.cardLastDigits = cardLastDigits
        self.created = created
        self.reasonCode = reasonCode
    }
    
    public init(JSON: [String : Any]) {
        self.init(
            status: (JSON["status"] as? String).flatMap(DisputeStatus.init(rawValue:)),
            cardLastDigits: (JSON["card_last_digits"] as? String).flatMap(LastDigits.init(lastDigitsString:)),
            created: JSON["created"].flatMap(DateComponentsConverter.convert(fromAttribute:)),
            reasonCode: JSON["reason_code"] as? String
        )
    }
}

extension Dispute: Listable {}
extension Dispute: Retrievable {}

extension Dispute: Updatable {
    public typealias UpdateParams = DisputeParams
}

extension Dispute: Searchable {
    public typealias FilterParams = DisputeFilterParams
}


extension Dispute {
    public static func list(using client: APIClient, state: DisputeStatusQuery, params: ListParams? = nil, callback: @escaping Dispute.ListRequest.Callback) -> Dispute.ListRequest? {
        let endpoint = ListEndpoint(
            pathComponents: [resourceInfo.path, state.rawValue],
            parameter: .get(nil)
        )
        
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}

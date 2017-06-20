import Foundation

public enum DisputeStatus: String, Decodable {
    case open
    case pending
    case won
    case lost
}


public struct Dispute: OmiseResourceObject {
    public enum Reason: Decodable {
        case cancelledRecurringTransaction
        case creditNotProcessed
        case duplicateProcessing
        case expiredCard
        case goodsOrServicesNotProvided
        case incorrectCurrency
        case incorrectTransactionAmount
        case latePresentment
        case notnMatchingAmountNumber
        case notAsDescribedOrDefectiveMerchandise
        case notRecorded
        case paidByOtherMeans
        case transactionNotRecognized
        case unauthorizedCharge
        
        case notAvailable
        case other
    }
    
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/disputes")
    
    public let object: String
    public let location: String
    
    public let id: String
    public let isLive: Bool
    public var createdDate: Date
    
    public var value: Value {
        return Value(amount: amount, currency: currency)
    }
    public let amount: Int64
    public let currency: Currency
    public var status: DisputeStatus
    public let reasonMessage: String
    public let reasonCode: Reason
    public var responseMessage: String?
    public let transaction: DetailProperty<Transaction>
    public let charge: DetailProperty<Charge>
    public let documents: ListProperty<Document>
    public let closedDate: Date?
}


extension Dispute {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Dispute.parseOmiseResource(JSON: json) else {
                return nil
        }
        
        guard let value = Value(JSON: json),
            let status = json["status"].flatMap(EnumConverter<DisputeStatus>.convert(fromAttribute:)),
            let reasonCode = json["reason_code"].flatMap(Reason.init(JSON:)),
            let reasonMessage = json["reason_message"] as? String,
            let transaction = json["transaction"].flatMap(DetailProperty<Transaction>.init(JSON:)),
            let charge = json["charge"].flatMap(DetailProperty<Charge>.init(JSON:)),
            let documents = json["documents"].flatMap(ListProperty<Document>.init(JSON:)) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate) = omiseObjectProperties
        self.amount = value.amount
        self.currency = value.currency
        self.status = status
        self.reasonCode = reasonCode
        self.reasonMessage = reasonMessage
        self.responseMessage = json["message"] as? String
        self.transaction = transaction
        self.charge = charge
        self.documents = documents
        self.closedDate = DateConverter.convert(fromAttribute: json["closed_at"])
    }
}

extension Dispute.Reason: Equatable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let code = try container.decode(String.self)
        switch code {
        case "cancelled_recurring_transaction":
            self = .cancelledRecurringTransaction
        case "credit_not_processed":
            self = .creditNotProcessed
        case "duplicate_processing":
            self = .duplicateProcessing
        case "expired_card":
            self = .expiredCard
        case "goods_or_services_not_provided":
            self = .goodsOrServicesNotProvided
        case "incorrect_currency":
            self = .incorrectCurrency
        case "incorrect_transaction_amount":
            self = .incorrectTransactionAmount
        case "late_presentment":
            self = .latePresentment
        case "non_matching_account_number":
            self = .notnMatchingAmountNumber
        case "not_as_described_or_defective_merchandise":
            self = .notAsDescribedOrDefectiveMerchandise
        case "not_recorded":
            self = .notRecorded
        case "paid_by_other_means":
            self = .paidByOtherMeans
        case "transaction_not_recognised":
            self = .transactionNotRecognized
        case "unauthorized_charge_aka_fraud":
            self = .unauthorizedCharge
            
        case "not_available":
            self = .cancelledRecurringTransaction
        case "other": fallthrough
        default:
            self = .other
        }
    }
    
    init?(JSON json: Any) {
        guard let code = json as? String else {
            return nil
        }
        
        switch code {
        case "cancelled_recurring_transaction":
            self = .cancelledRecurringTransaction
        case "credit_not_processed":
            self = .creditNotProcessed
        case "duplicate_processing":
            self = .duplicateProcessing
        case "expired_card":
            self = .expiredCard
        case "goods_or_services_not_provided":
            self = .goodsOrServicesNotProvided
        case "incorrect_currency":
            self = .incorrectCurrency
        case "incorrect_transaction_amount":
            self = .incorrectTransactionAmount
        case "late_presentment":
            self = .latePresentment
        case "non_matching_account_number":
            self = .notnMatchingAmountNumber
        case "not_as_described_or_defective_merchandise":
            self = .notAsDescribedOrDefectiveMerchandise
        case "not_recorded":
            self = .notRecorded
        case "paid_by_other_means":
            self = .paidByOtherMeans
        case "transaction_not_recognised":
            self = .transactionNotRecognized
        case "unauthorized_charge_aka_fraud":
            self = .unauthorizedCharge

        case "not_available":
            self = .cancelledRecurringTransaction
        case "other": fallthrough
        default:
            self = .other
        }
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

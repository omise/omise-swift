import Foundation

public enum DisputeStatus: String, Codable {
    case open
    case pending
    case won
    case lost
}


public struct Dispute: OmiseResourceObject {
    public enum Reason: Codable {
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
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case isLive = "livemode"
        case createdDate = "created"
        case amount
        case currency
        case status
        case reasonMessage = "reason_message"
        case reasonCode = "reason_code"
        case responseMessage = "message"
        case transaction
        case charge
        case documents
        case closedDate = "closed_at"
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
            self = .notAvailable
        case "other": fallthrough
        default:
            self = .other
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .cancelledRecurringTransaction:
            try container.encode("cancelled_recurring_transaction")
        case .creditNotProcessed:
            try container.encode("credit_not_processed")
        case .duplicateProcessing:
            try container.encode("duplicate_processing")
        case .expiredCard:
            try container.encode("expired_card")
        case .goodsOrServicesNotProvided:
            try container.encode("goods_or_services_not_provided")
        case .incorrectCurrency:
            try container.encode("incorrect_currency")
        case .incorrectTransactionAmount:
            try container.encode("incorrect_transaction_amount")
        case .latePresentment:
            try container.encode("late_presentment")
        case .notnMatchingAmountNumber:
            try container.encode("non_matching_account_number")
        case .notAsDescribedOrDefectiveMerchandise:
            try container.encode("not_as_described_or_defective_merchandise")
        case .notRecorded:
            try container.encode("not_recorded")
        case .paidByOtherMeans:
            try container.encode("paid_by_other_means")
        case .transactionNotRecognized:
            try container.encode("transaction_not_recognised")
        case .unauthorizedCharge:
            try container.encode("unauthorized_charge_aka_fraud")
        case .notAvailable:
            try container.encode("not_available")
        case .other:
            try container.encode("other")
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
    
    public init(message: String?) {
        self.message = message
    }
}

public struct DisputeFilterParams: OmiseFilterParams {
    public var created: DateComponents?
    public var cardLastDigits: LastDigits?
    public var reasonCode: String?
    public var status: DisputeStatus?
    
    private enum CodingKeys: String, CodingKey {
        case created
        case cardLastDigits = "card_last_digits"
        case reasonCode = "reason_code"
        case status
    }
    
    public init(status: DisputeStatus? = nil, cardLastDigits: LastDigits? = nil,
                created: DateComponents? = nil, reasonCode: String? = nil) {
        self.status = status
        self.cardLastDigits = cardLastDigits
        self.created = created
        self.reasonCode = reasonCode
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        created = try container.decodeIfPresent(String.self, forKey: .created).flatMap(DateComponentsConverter.convert(fromAttribute:))
        cardLastDigits = try container.decodeIfPresent(LastDigits.self, forKey: .cardLastDigits)
        reasonCode = try container.decodeIfPresent(String.self, forKey: .reasonCode)
        status = try container.decodeIfPresent(DisputeStatus.self, forKey: .status)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(DateComponentsConverter.convert(fromValue: created), forKey: .created)
        try container.encodeIfPresent(cardLastDigits, forKey: .cardLastDigits)
        try container.encodeIfPresent(reasonCode, forKey: .reasonCode)
        try container.encodeIfPresent(status, forKey: .status)
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

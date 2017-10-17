import Foundation

public enum DisputeStatus: String, Codable, Equatable {
    case open
    case pending
    case won
    case lost
}


public struct Dispute: OmiseResourceObject, Equatable {
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
    public let transaction: DetailProperty<Transaction<Dispute>>
    public let charge: DetailProperty<Charge>
    public let documents: ListProperty<Document>
    public let closedDate: Date?
    
    public var metadata: JSONDictionary
    
}

    
extension Dispute {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        object = try container.decode(String.self, forKey: .object)
        location = try container.decode(String.self, forKey: .location)
        id = try container.decode(String.self, forKey: .id)
        isLive = try container.decode(Bool.self, forKey: .isLive)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        amount = try container.decode(Int64.self, forKey: .amount)
        currency = try container.decode(Currency.self, forKey: .currency)
        status = try container.decode(DisputeStatus.self, forKey: .status)
        reasonMessage = try container.decode(String.self, forKey: .reasonMessage)
        reasonCode = try container.decode(Reason.self, forKey: .reasonCode)
        responseMessage = try container.decodeIfPresent(String.self, forKey: .responseMessage)
        transaction = try container.decode(DetailProperty<Transaction>.self, forKey: .transaction)
        charge = try container.decode(DetailProperty<Charge>.self, forKey: .charge)
        documents = try container.decode(ListProperty<Document>.self, forKey: .documents)
        closedDate = try container.decodeIfPresent(Date.self, forKey: .closedDate)
        metadata = try container.decode(Dictionary<String, Any>.self, forKey: .metadata)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(object, forKey: .object)
        try container.encode(location, forKey: .location)
        try container.encode(id, forKey: .id)
        try container.encode(isLive, forKey: .isLive)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(amount, forKey: .amount)
        try container.encode(currency, forKey: .currency)
        try container.encode(status, forKey: .status)
        try container.encode(reasonMessage, forKey: .reasonMessage)
        try container.encode(reasonCode, forKey: .reasonCode)
        try container.encode(responseMessage, forKey: .responseMessage)
        try container.encode(transaction, forKey: .transaction)
        try container.encode(charge, forKey: .charge)
        try container.encode(documents, forKey: .documents)
        try container.encode(closedDate, forKey: .closedDate)
        try container.encode(metadata, forKey: .metadata)
    }

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
        case metadata
    }
}


extension Dispute {
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
    public var amount: Double?
    public var cardLastDigits: LastDigits?
    public var closedDate: DateComponents?
    public var createdDate: DateComponents?
    public var currency: Currency?
    public var status: DisputeStatus?
    
    private enum CodingKeys: String, CodingKey {
        case amount
        case cardLastDigits = "card_last_digits"
        case closedDate = "closed_at"
        case createdDate = "created"
        case currency
        case status
    }
    
    public init(amount: Double? = nil, cardLastDigits: LastDigits? = nil,
                closedDate: DateComponents? = nil, createdDate: DateComponents? = nil,
                currency: Currency? = nil, status: DisputeStatus? = nil) {
        self.amount = amount
        self.cardLastDigits = cardLastDigits
        self.closedDate = closedDate
        self.createdDate = createdDate
        self.currency = currency
        self.status = status
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decodeOmiseAPIValueIfPresent(Double.self, forKey: .amount)
        cardLastDigits = try container.decodeIfPresent(LastDigits.self, forKey: .cardLastDigits)
        closedDate = try container.decodeOmiseDateComponentsIfPresent(forKey: .closedDate)
        createdDate = try container.decodeOmiseDateComponentsIfPresent(forKey: .createdDate)
        currency = try container.decodeIfPresent(Currency.self, forKey: .currency)
        status = try container.decodeIfPresent(DisputeStatus.self, forKey: .status)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(cardLastDigits, forKey: .cardLastDigits)
        try container.encodeOmiseDateComponentsIfPresent(closedDate, forKey: .closedDate)
        try container.encodeOmiseDateComponentsIfPresent(createdDate, forKey: .createdDate)
        try container.encodeIfPresent(currency, forKey: .currency)
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

import Foundation


public struct Charge: OmiseResourceObject, Equatable {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/charges")
    
    public let object: String
    public let location: String
    
    public let id: String
    public let isLive: Bool
    public let createdDate: Date
    
    public var status: Charge.Status
    public var value: Value {
        return Value(amount: amount, currency: currency)
    }
    
    public let amount: Int64
    public let currency: Currency
    
    public let fundingAmount: Int64
    public let fundingCurrency: Currency
    public var fundingValue: Value {
        return Value(amount: fundingAmount, currency: fundingCurrency)
    }
    
    public var chargeDescription: String?
    
    public let isAutoCapture: Bool
    
    public let isAuthorized: Bool
    public let isPaid: Bool
    public let paidDate: Date?
    
    public let isReversed: Bool
    public let isVoided: Bool
    
    public let isDisputable: Bool
    public let isCapturable: Bool
    public let isReversible: Bool
    public let isRefundable: Bool
    
    public var transaction: DetailProperty<Transaction<Charge>>?
    
    public var card: Card?
    public var source: EnrolledSource?
    
    public let payment: Charge.Payment
    
    public var paymentInformation: Charge.PaymentInformation {
        switch payment {
        case .card(let card):
            return .card(card)
        case .source(let source):
            return .source(source.paymentInformation)
        case .unknown:
            return .unknown
        }
    }
    
    public var refunded: Int64?
    public var refunds: ListProperty<Refund>?
    
    public var customer: DetailProperty<Customer>?
    
    public var ipAddress: String?
    public var dispute: Dispute?
    
    public let returnURL: URL?
    public let authorizedURL: URL?
    
    public let metadata: JSONDictionary
}

extension Charge {
    
    public enum Status : Equatable {
        case failed(ChargeFailure)
        case expired
        case reversed
        case pending
        case successful
        case unknown(String)
    }
    
    public enum APIStatus: String, Codable, Equatable {
        case successful
        case pending
        case reversed
        case expired
        case failed
    }
    
    public enum SourceOfFund : String, Codable, Equatable {
        case card
        case offsite
        case offline
    }
    
    public enum Payment {
        case card(Card)
        case source(EnrolledSource)
        case unknown
    }
    
    public enum PaymentInformation {
        case card(Card)
        case source(EnrolledSource.EnrolledPaymentInformation)
        case unknown
    }
    
}

extension Charge {
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case isLive = "livemode"
        case createdDate = "created"
        case status
        case failureCode = "failure_code"
        case failureMessage = "failure_message"
        case amount
        case currency
        case fundingAmount = "funding_amount"
        case fundingCurrency = "funding_currency"
        case paidDate = "paid_at"
        case isReversed = "reversed"
        case chargeDescription = "description"
        case isAutoCapture = "capture"
        case isAuthorized = "authorized"
        case isPaid = "paid"
        case isVoided = "voided"
        case isDisputable = "disputable"
        case isCapturable = "capturable"
        case isReversible = "reversible"
        case isRefundable = "refundable"
        case isCaptured = "captured"
        case transaction
        case card
        case source
        case refunded
        case refunds
        case customer
        case ipAddress = "ip"
        case dispute
        case returnURL = "return_uri"
        case authorizedURL = "authorized_uri"
        case metadata
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decode(String.self, forKey: .object)
        location = try container.decode(String.self, forKey: .location)
        id = try container.decode(String.self, forKey: .id)
        isLive = try container.decode(Bool.self, forKey: .isLive)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        amount = try container.decode(Int64.self, forKey: .amount)
        currency = try container.decode(Currency.self, forKey: .currency)
        fundingAmount = try container.decode(Int64.self, forKey: .fundingAmount)
        fundingCurrency = try container.decode(Currency.self, forKey: .fundingCurrency)
        chargeDescription = try container.decodeIfPresent(String.self, forKey: .chargeDescription)
        isAutoCapture = try container.decode(Bool.self, forKey: .isAutoCapture)
        isAuthorized = try container.decode(Bool.self, forKey: .isAuthorized)
        do {
            isPaid = try container.decode(Bool.self, forKey: .isCaptured)
        } catch DecodingError.keyNotFound {
            isPaid = try container.decode(Bool.self, forKey: .isPaid)
        }
        paidDate = try container.decodeIfPresent(Date.self, forKey: .paidDate)
        isReversed = try container.decode(Bool.self, forKey: .isReversed)
        isVoided = try container.decode(Bool.self, forKey: .isVoided)
        isDisputable = try container.decode(Bool.self, forKey: .isDisputable)
        isCapturable = try container.decode(Bool.self, forKey: .isCapturable)
        isReversible = try container.decode(Bool.self, forKey: .isReversible)
        isRefundable = try container.decode(Bool.self, forKey: .isRefundable)

        transaction = try container.decodeIfPresent(DetailProperty<Transaction>.self, forKey: .transaction)
        refunded = try container.decodeIfPresent(Int64.self, forKey: .refunded)
        refunds = try container.decodeIfPresent(ListProperty<Refund>.self, forKey: .refunds)
        customer = try container.decodeIfPresent(DetailProperty<Customer>.self, forKey: .customer)
        ipAddress = try container.decodeIfPresent(String.self, forKey: .ipAddress)
        dispute = try container.decodeIfPresent(Dispute.self, forKey: .dispute)
        returnURL = try container.decodeIfPresent(URL.self, forKey: .returnURL)
        authorizedURL = try container.decodeIfPresent(URL.self, forKey: .authorizedURL)
        metadata = try container.decode([String: Any].self, forKey: .metadata)
        
        let statusValue = try container.decode(String.self, forKey: .status)
        let failureCode = try container.decodeIfPresent(ChargeFailure.Code.self, forKey: .failureCode)
        let failureMessage = try container.decodeIfPresent(String.self, forKey: .failureMessage)
        
        let status: Charge.Status
        switch (statusValue, failureCode, failureMessage) {
        case (Charge.APIStatus.failed.rawValue, let failureCode?, let failureMessage?):
            status = .failed(ChargeFailure(code: failureCode, message: failureMessage))
        case (Charge.APIStatus.expired.rawValue, nil, nil):
            status = .expired
        case (Charge.APIStatus.successful.rawValue, nil, nil):
            status = .successful
        case (Charge.APIStatus.pending.rawValue, nil, nil):
            status = .pending
        case (Charge.APIStatus.reversed.rawValue, nil, nil):
            status = .reversed
        case (let statusValue, nil, nil):
            status = .unknown(statusValue)
        case (_, .some, .some), (_, .some, .none), (_, .none, .some):
            throw DecodingError.dataCorruptedError(
                forKey: .failureCode, in: container,
                debugDescription: "Invalid Charge Failure status."
            )
        }
        
        self.status = status
        
        source = try container.decodeIfPresent(EnrolledSource.self, forKey: .source)
        card = try container.decodeIfPresent(Card.self, forKey: .card)
        
        switch (card, source) {
        case (let card?, nil):
            payment = .card(card)
        case (nil, let source?):
            payment = .source(source)
        case (nil, nil), (.some, .some):
            payment = .unknown
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(object, forKey: .object)
        try container.encode(location, forKey: .location)
        try container.encode(id, forKey: .id)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(isLive, forKey: .isLive)

        try container.encode(amount, forKey: .amount)
        try container.encode(currency, forKey: .currency)
        try container.encode(fundingAmount, forKey: .fundingAmount)
        try container.encode(fundingCurrency, forKey: .fundingCurrency)
        try container.encodeIfPresent(chargeDescription, forKey: .chargeDescription)
        try container.encode(isAutoCapture, forKey: .isAutoCapture)
        try container.encode(isAuthorized, forKey: .isAuthorized)
        try container.encode(isPaid, forKey: .isPaid)
        try container.encodeIfPresent(paidDate, forKey: .paidDate)

        try container.encode(isReversed, forKey: .isReversed)
        try container.encode(isVoided, forKey: .isVoided)
        try container.encode(isDisputable, forKey: .isDisputable)
        try container.encode(isCapturable, forKey: .isCapturable)
        try container.encode(isReversible, forKey: .isReversible)
        try container.encode(isRefundable, forKey: .isRefundable)

        try container.encodeIfPresent(transaction, forKey: .transaction)
        try container.encodeIfPresent(refunded, forKey: .refunded)
        try container.encodeIfPresent(refunds, forKey: .refunds)
        try container.encodeIfPresent(customer, forKey: .customer)
        try container.encodeIfPresent(ipAddress, forKey: .ipAddress)
        try container.encodeIfPresent(dispute, forKey: .dispute)
        try container.encodeIfPresent(returnURL, forKey: .returnURL)
        try container.encodeIfPresent(authorizedURL, forKey: .authorizedURL)
        try container.encode(metadata, forKey: .metadata)
        
        switch status {
        case .successful:
            try container.encode(Charge.APIStatus.successful, forKey: .status)
        case .pending:
            try container.encode(Charge.APIStatus.pending, forKey: .status)
        case .reversed:
            try container.encode(Charge.APIStatus.reversed, forKey: .status)
        case .expired:
            try container.encode(Charge.APIStatus.expired, forKey: .status)
        case .failed(let failure):
            try container.encode(Charge.APIStatus.failed, forKey: .status)
            try container.encode(failure.code, forKey: .failureCode)
            try container.encode(failure.message, forKey: .failureMessage)
        case .unknown(let statusValue):
            try container.encode(statusValue, forKey: .status)
        }
        
        switch payment {
        case .card(let card):
            try container.encodeIfPresent(card, forKey: .card)
        case .source(let source):
            try container.encodeIfPresent(source, forKey: .source)
        case .unknown:
            break
        }
    }
}


public struct ChargeParams: APIJSONQuery {
    
    public enum Payment {
        case card(cardID: String)
        case customer(customerID: String, cardID: String?)
        case source(PaymentSource)
        case sourceType(PaymentSourceParams.SourceParameter)
    }
    
    public var value: Value
    public var payment: Payment
    public var chargeDescription: String?
    public var isAutoCapture: Bool?
    public var returnURL: URL?
    
    public var metadata: [String: Any]?
    
    private enum CodingKeys: String, CodingKey {
        case customerID = "customer"
        case cardID = "card"
        case sourceID = "source"
        case amount
        case currency
        case chargeDescription = "description"
        case isAutoCapture = "capture"
        case returnURL = "return_uri"
        case metadata
        
        fileprivate enum SourceCodingKeys: String, CodingKey {
            case type
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(value.amount, forKey: .amount)
        try container.encode(value.currency, forKey: .currency)
        switch payment {
        case .card(cardID: let cardID):
            try container.encode(cardID, forKey: .cardID)
        case .customer(customerID: let customerID, cardID: let cardID):
            try container.encode(customerID, forKey: .customerID)
            try container.encodeIfPresent(cardID, forKey: .cardID)
        case .source(let source):
            try container.encode(source.id, forKey: .sourceID)
        case .sourceType(let sourceType):
            try container.encode(sourceType, forKey: .sourceID)
        }
        try container.encodeIfPresent(chargeDescription, forKey: .chargeDescription)
        try container.encodeIfPresent(isAutoCapture, forKey: .isAutoCapture)
        try container.encodeIfPresent(returnURL, forKey: .returnURL)
        try container.encodeIfPresent(metadata, forKey: .metadata)
    }
    
    private init(value: Value, payment: Payment, chargeDescription: String?, isAutoCapture: Bool?, returnURL: URL?, metadata: [String: Any]?) {
        self.value = value
        self.payment = payment
        self.chargeDescription = chargeDescription
        self.isAutoCapture = isAutoCapture
        self.returnURL = returnURL
        self.metadata = metadata
    }
    
    public init(value: Value, customerID: String, cardID: String? = nil, chargeDescription: String? = nil, isAutoCapture: Bool? = nil, returnURL: URL? = nil, metadata: [String: Any]? = nil) {
        self.init(value: value, payment: .customer(customerID: customerID, cardID: cardID), chargeDescription: chargeDescription, isAutoCapture: isAutoCapture, returnURL: returnURL, metadata: metadata)
    }
    
    public init(value: Value, cardID: String, chargeDescription: String? = nil, isAutoCapture: Bool? = nil, returnURL: URL? = nil, metadata: [String: Any]? = nil) {
        self.init(value: value, payment: .card(cardID: cardID), chargeDescription: chargeDescription, isAutoCapture: isAutoCapture, returnURL: returnURL, metadata: metadata)
    }
    
    public init(value: Value, source: PaymentSource, chargeDescription: String? = nil, isAutoCapture: Bool? = nil, returnURL: URL? = nil, metadata: [String: Any]? = nil) {
        self.init(value: value, payment: .source(source), chargeDescription: chargeDescription, isAutoCapture: isAutoCapture, returnURL: returnURL, metadata: metadata)
    }
    
    public init(value: Value, sourceType: PaymentSourceParams.SourceParameter, chargeDescription: String? = nil, isAutoCapture: Bool? = nil, returnURL: URL? = nil, metadata: [String: Any]? = nil) {
        self.init(value: value, payment: .sourceType(sourceType), chargeDescription: chargeDescription, isAutoCapture: isAutoCapture, returnURL: returnURL, metadata: metadata)
    }
}

public struct UpdateChargeParams: APIJSONQuery {
    public var chargeDescription: String?
    public var metadata: [String: Any]?
    
    private enum CodingKeys: String, CodingKey {
        case chargeDescription = "description"
        case metadata
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(chargeDescription, forKey: .chargeDescription)
        try container.encodeIfPresent(metadata, forKey: .metadata)
    }
    
    public init(chargeDescription: String? = nil, metadata: [String: Any]? = nil) {
        self.chargeDescription = chargeDescription
        self.metadata = metadata
    }
}

public struct ChargeFilterParams: OmiseFilterParams {
    public var amount: Double?
    public var isAuthorized: Bool?
    public var isAutoCapture: Bool?
    public var isCaptured: Bool?
    public var capturedDate: DateComponents?
    public var cardLastDigits: LastDigits?
    public var createdDate: DateComponents?
    public var isCustomerPresent: Bool?
    public var isDisputed: Bool?
    public var failureCode: ChargeFailure.Code?
    public var failureMessage: String?
    public var isRefunded: Bool?
    public var refundAmount: Double?
    public var isReversed: Bool?
    public var status: Charge.APIStatus?
    public var sourceOfFund: Charge.SourceOfFund?
    public var isVoided: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case amount
        case isAuthorized = "authorized"
        case isAutoCapture = "capture"
        case isCaptured = "captured"
        case capturedDate = "captured_at"
        case cardLastDigits = "card_last_digits"
        case createdDate = "created"
        case isCustomerPresent = "customer_present"
        case isDisputed = "disputed"
        case failureCode = "failure_code"
        case failureMessage = "failure_message"
        case isRefunded = "refunded"
        case refundAmount = "refund_amount"
        case isReversed = "reversed"
        case status = "status"
        case sourceOfFund = "source_of_fund"
        case isVoided = "voided"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decodeOmiseAPIValueIfPresent(Double.self, forKey: .amount)
        isAuthorized = try container.decodeOmiseAPIValueIfPresent(Bool.self, forKey: .isAuthorized)
        isAutoCapture = try container.decodeOmiseAPIValueIfPresent(Bool.self, forKey: .isAutoCapture)
        isCaptured = try container.decodeOmiseAPIValueIfPresent(Bool.self, forKey: .isCaptured)
        capturedDate = try container.decodeOmiseDateComponentsIfPresent(forKey: .capturedDate)
        cardLastDigits = try container.decodeIfPresent(LastDigits.self, forKey: .cardLastDigits)
        createdDate = try container.decodeOmiseDateComponentsIfPresent(forKey: .createdDate)
        isCustomerPresent = try container.decodeOmiseAPIValueIfPresent(Bool.self, forKey: .isCustomerPresent)
        isDisputed = try container.decodeOmiseAPIValueIfPresent(Bool.self, forKey: .isDisputed)
        failureCode = try container.decodeIfPresent(ChargeFailure.Code.self, forKey: .failureCode)
        failureMessage = try container.decodeIfPresent(String.self, forKey: .failureMessage)
        isRefunded = try container.decodeOmiseAPIValueIfPresent(Bool.self, forKey: .isRefunded)
        refundAmount = try container.decodeOmiseAPIValueIfPresent(Double.self, forKey: .refundAmount)
        isReversed = try container.decodeOmiseAPIValueIfPresent(Bool.self, forKey: .isReversed)
        status = try container.decodeIfPresent(Charge.APIStatus.self, forKey: .status)
        sourceOfFund = try container.decodeIfPresent(Charge.SourceOfFund.self, forKey: .sourceOfFund)
        isVoided = try container.decodeOmiseAPIValueIfPresent(Bool.self, forKey: .isVoided)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(isAuthorized, forKey: .isAuthorized)
        try container.encodeIfPresent(isAutoCapture, forKey: .isAutoCapture)
        try container.encodeIfPresent(isCaptured, forKey: .isCaptured)
        try container.encodeOmiseDateComponentsIfPresent(capturedDate, forKey: .capturedDate)
        try container.encodeIfPresent(cardLastDigits, forKey: .cardLastDigits)
        try container.encodeOmiseDateComponentsIfPresent(createdDate, forKey: .createdDate)
        try container.encodeIfPresent(isCustomerPresent, forKey: .isCustomerPresent)
        try container.encodeIfPresent(isDisputed, forKey: .isDisputed)
        try container.encodeIfPresent(failureCode, forKey: .failureCode)
        try container.encodeIfPresent(failureMessage, forKey: .failureMessage)
        try container.encodeIfPresent(isRefunded, forKey: .isRefunded)
        try container.encodeIfPresent(refundAmount, forKey: .refundAmount)
        try container.encodeIfPresent(isReversed, forKey: .isReversed)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(sourceOfFund, forKey: .sourceOfFund)
        try container.encodeIfPresent(isVoided, forKey: .isVoided)
    }
    
    public init(amount: Double? = nil, isAuthorized: Bool? = nil,
                isAutoCapture: Bool? = nil, isCaptured: Bool? = nil,
                capturedDate: DateComponents? = nil,
                cardLastDigits: LastDigits? = nil,
                createdDate: DateComponents? = nil,
                isCustomerPresent: Bool? = nil,
                isDisputed: Bool? = nil,
                failureCode: ChargeFailure.Code? = nil, failureMessage: String? = nil,
                isRefunded: Bool? = nil, refundAmount: Double? = nil,
                isReversed: Bool? = nil, status: Charge.APIStatus? = nil,
                sourceOfFund: Charge.SourceOfFund? = nil, isVoided: Bool? = nil) {
        self.amount = amount
        self.isAuthorized = isAuthorized
        self.isAutoCapture = isAutoCapture
        self.capturedDate = capturedDate
        self.isCaptured = isCaptured
        self.cardLastDigits = cardLastDigits
        self.createdDate = createdDate
        self.isCustomerPresent = isCustomerPresent
        self.isDisputed = isDisputed
        self.failureCode = failureCode
        self.isRefunded = isRefunded
        self.failureMessage = failureMessage
        self.refundAmount = refundAmount
        self.isReversed = isReversed
        self.status = status
        self.sourceOfFund = sourceOfFund
        self.isVoided = isVoided
    }
}

public struct ChargeSchedulingParameter: SchedulingParameter, APIJSONQuery {
    public let value: Value
    public let customerID: String
    public let cardID: String?
    public let chargeDescription: String?
    
    public init(value: Value, customerID: String, cardID: String?, description: String?) {
        self.value = value
        self.customerID = customerID
        self.cardID = cardID
        self.chargeDescription = description
    }
    
    private enum CodingKeys: String, CodingKey {
        case customerID = "customer"
        case amount
        case currency
        case cardID = "card"
        case chargeDescription = "description"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cardID = try container.decodeIfPresent(String.self, forKey: .cardID)
        let amount = try container.decode(Int64.self, forKey: .amount)
        let currency = try container.decode(Currency.self, forKey: .currency)
        
        self.value = Value(amount: amount, currency: currency)
        customerID = try container.decode(String.self, forKey: .customerID)
        chargeDescription = try container.decodeIfPresent(String.self, forKey: .chargeDescription)
    }
    
    public func encode(to encoder: Encoder) throws {
        var keyedContainer = encoder.container(keyedBy: CodingKeys.self)
        try keyedContainer.encode(customerID, forKey: .customerID)
        try keyedContainer.encode(value.amount, forKey: .amount)
        try keyedContainer.encode(value.currency, forKey: .currency)
        try keyedContainer.encodeIfPresent(cardID, forKey: .cardID)
        try keyedContainer.encodeIfPresent(chargeDescription, forKey: .chargeDescription)
    }
}


extension Charge: Listable {}
extension Charge: Retrievable {}

extension Charge: Creatable {
    public typealias CreateParams = ChargeParams
}

extension Charge: Updatable {
    public typealias UpdateParams = UpdateChargeParams
}

extension Charge: Searchable {
    public typealias FilterParams = ChargeFilterParams
}

extension Charge: Schedulable, APISchedulable {
    public typealias Parameter = ChargeSchedulingParameter
    public typealias ScheduleDataParams = ChargeSchedulingParameter
}



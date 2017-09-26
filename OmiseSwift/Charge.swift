import Foundation


public enum ChargeStatus {
    case failed(ChargeFailure)
    case reversed
    case pending
    case successful
}


public struct Charge: OmiseResourceObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/charges")
    
    public let object: String
    public let location: String
    
    public let id: String
    public let isLive: Bool
    public let createdDate: Date
    
    public var status: ChargeStatus
    public var value: Value {
        return Value(amount: amount, currency: currency)
    }
    
    public let amount: Int64
    public let currency: Currency
    
    public var chargeDescription: String?
    
    public let isAutoCapture: Bool
    
    public let isAuthorized: Bool
    public let isPaid: Bool
    
    public var transaction: DetailProperty<Transaction>?
    
    public var card: Card?
    public var offsite: OffsitePayment?
    public var payment: Payment
    
    public var refunded: Int64?
    public var refunds: ListProperty<Refund>?
    
    public var customer: DetailProperty<Customer>?
    
    public var ipAddress: String?
    public var dispute: Dispute?
    
    public let returnURL: URL?
    public let authorizedURL: URL?
    
    public let metadata: [String: Any]
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
        case amount
        case currency
        case chargeDescription = "description"
        case isAutoCapture = "capture"
        case isAuthorized = "authorized"
        case isPaid = "paid"
        case isCaptured = "captured"
        case transaction
        case card
        case offsite
        case refunded
        case refunds
        case customer
        case ipAddress = "ip"
        case dispute
        case returnURL = "return_uri"
        case authorizedURL = "authorized_uri"
        case metadata
        
        case sourceOfFund = "source_of_fund"
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
        chargeDescription = try container.decodeIfPresent(String.self, forKey: .chargeDescription)
        isAutoCapture = try container.decode(Bool.self, forKey: .isAutoCapture)
        isAuthorized = try container.decode(Bool.self, forKey: .isAuthorized)
        do {
            isPaid = try container.decode(Bool.self, forKey: .isCaptured)
        } catch DecodingError.keyNotFound {
            isPaid = try container.decode(Bool.self, forKey: .isPaid)
        }
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
        let failureCode = try container.decodeIfPresent(ChargeFailure.self, forKey: .failureCode)
        
        let status: ChargeStatus
        switch (statusValue, failureCode) {
        case ("failed", let failureCode?):
            status = .failed(failureCode)
        case ("successful", nil):
            status = .successful
        case ("pending", nil):
            status = .pending
        case ("reversed", nil):
            status = .reversed
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid charge status"))
        }
        
        self.status = status
        
        let payment: Payment?
        let card: Card?
        let offsite: OffsitePayment?
        
        let sourceOfFund = try container.decodeIfPresent(String.self, forKey: .sourceOfFund)
        
        switch sourceOfFund {
        case "offsite"?:
            card = nil
            offsite = try container.decode(OffsitePayment.self, forKey: .offsite)
            payment = offsite.map(Payment.offsite)
        case "card"?, nil:
            offsite = nil
            card = try container.decode(Card.self, forKey: .card)
            payment = card.map(Payment.card)
        default:
            let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid payment value")
            throw DecodingError.dataCorrupted(context)
        }
        
        if let payment = payment {
            self.payment = payment
            self.card = card
            self.offsite = offsite
        } else {
            let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid payment value")
            throw DecodingError.dataCorrupted(context)
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
        try container.encodeIfPresent(chargeDescription, forKey: .chargeDescription)
        try container.encode(isAutoCapture, forKey: .isAutoCapture)
        try container.encode(isAuthorized, forKey: .isAuthorized)
        try container.encode(isPaid, forKey: .isPaid)
        
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
            try container.encode("successful", forKey: .status)
        case .pending:
            try container.encode("pending", forKey: .status)
        case .reversed:
            try container.encode("reversed", forKey: .status)
        case .failed(let failureCode):
            try container.encode("failed", forKey: .status)
            try container.encode(failureCode, forKey: .failureCode)
        }
    }
}


public struct ChargeParams: APIJSONQuery {
    public var customerID: String?
    public var cardID: String?
    public var value: Value
    public var chargeDescription: String?
    public var isAutoCapture: Bool?
    public var returnURL: URL?
    
    public var metadata: [String: Any]?
    
    private enum CodingKeys: String, CodingKey {
        case customerID = "customer"
        case cardID = "card"
        case amount
        case currency
        case chargeDescription = "description"
        case isAutoCapture = "capture"
        case returnURL = "return_uri"
        case metadata
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(value.amount, forKey: .amount)
        try container.encode(value.currency, forKey: .currency)
        try container.encodeIfPresent(customerID, forKey: .customerID)
        try container.encodeIfPresent(cardID, forKey: .cardID)
        try container.encodeIfPresent(chargeDescription, forKey: .chargeDescription)
        try container.encodeIfPresent(isAutoCapture, forKey: .isAutoCapture)
        try container.encodeIfPresent(returnURL, forKey: .returnURL)
        try container.encodeIfPresent(metadata, forKey: .metadata)
    }
    
    public init(value: Value, chargeDescription: String? = nil, customerID: String? = nil, cardID: String? = nil, isAutoCapture: Bool? = nil, returnURL: URL? = nil, metadata: [String: Any]? = nil) {
        self.value = value
        self.chargeDescription = chargeDescription
        self.customerID = customerID
        self.cardID = cardID
        self.isAutoCapture = isAutoCapture
        self.returnURL = returnURL
        self.metadata = metadata
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
    public var created: DateComponents?
    public var amount: Double?
    public var isAuthorized: Bool?
    public var isCaptured: Bool?
    public var cardLastDigits: LastDigits?
    public var isCustomerPresent: Bool?
    public var failureCode: ChargeFailure?
    
    private enum CodingKeys: String, CodingKey {
        case created
        case amount
        case isAuthorized = "authorized"
        case isCaptured = "captured"
        case cardLastDigits = "card_last_digits"
        case isCustomerPresent = "customer_present"
        case failureCode = "failure_code"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        created = try container.decodeOmiseDateComponentsIfPresent(forKey: .created)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        isAuthorized = try container.decodeIfPresent(Bool.self, forKey: .isAuthorized)
        isCaptured = try container.decodeIfPresent(Bool.self, forKey: .isCaptured)
        cardLastDigits = try container.decodeIfPresent(LastDigits.self, forKey: .cardLastDigits)
        isCustomerPresent = try container.decodeIfPresent(Bool.self, forKey: .isCustomerPresent)
        failureCode = try container.decodeIfPresent(ChargeFailure.self, forKey: .failureCode)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeOmiseDateComponentsIfPresent(created, forKey: .created)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(isAuthorized, forKey: .isAuthorized)
        try container.encodeIfPresent(isCaptured, forKey: .isCaptured)
        try container.encodeIfPresent(cardLastDigits, forKey: .cardLastDigits)
        try container.encodeIfPresent(isCustomerPresent, forKey: .isCustomerPresent)
        try container.encodeIfPresent(failureCode, forKey: .failureCode)
    }
    
    public init(created: DateComponents? = nil, amount: Double? = nil,
                isAuthorized: Bool? = nil, isCaptured: Bool? = nil,
                cardLastDigits: LastDigits? = nil,
                isCustomerPresent: Bool? = nil,
                failureCode: ChargeFailure? = nil) {
        self.created = created
        self.amount = amount
        self.isAuthorized = isAuthorized
        self.isCaptured = isCaptured
        self.cardLastDigits = cardLastDigits
        self.isCustomerPresent = isCustomerPresent
        self.failureCode = failureCode
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






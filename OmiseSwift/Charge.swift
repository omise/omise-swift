import Foundation


public enum ChargeStatus {
    case failed(ChargeFailure)
    case reversed
    case pending
    case successful
}

extension ChargeStatus {
    init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let status = json["status"] as? String else {
                return nil
        }
        
        let failureCode = ChargeFailure(JSON: json)
        
        switch (status, failureCode) {
        case ("failed", let failureCode?):
            self = .failed(failureCode)
        case ("successful", nil):
            self = .successful
        case ("pending", nil):
            self = .pending
        case ("reversed", nil):
            self = .reversed
        default:
            return nil
        }
    }
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
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Charge.parseOmiseResource(JSON: json) else {
                return nil
        }
        
        guard let value = Value(JSON: json), let isAutoCapture = json["capture"] as? Bool,
            let isAuthorized = json["authorized"] as? Bool, let isPaid = json["paid"] as? Bool ?? json["captured"] as? Bool,
            let status = ChargeStatus(JSON: json) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate) = omiseObjectProperties
        self.status = status
        self.amount = value.amount
        self.currency = value.currency
        self.isAuthorized = isAuthorized
        self.isAutoCapture = isAutoCapture
        self.isPaid = isPaid
        
        self.customer = json["customer"].flatMap(DetailProperty<Customer>.init(JSON:))
        self.transaction = json["transaction"].flatMap(DetailProperty<Transaction>.init(JSON:))
        
        self.ipAddress = json["ip"] as? String
        self.returnURL = (json["return_uri"] as? String).flatMap(URL.init(string:))
        self.authorizedURL = (json["authorized_uri"] as? String).flatMap(URL.init(string:))
        
        self.refunded = json["refunded"] as? Int64
        self.refunds = json["refunds"].flatMap(ListProperty<Refund>.init(JSON:))
        
        self.chargeDescription = json["description"] as? String
        
        self.metadata = json["metadata"] as? [String: Any] ?? [:]
        self.dispute = json["dispute"].flatMap(Dispute.init(JSON:))
        
        let payment: Payment?
        let card: Card?
        let offsite: OffsitePayment?
        
        switch json["source_of_fund"] as? String {
        case "offsite"?:
            card = nil
            offsite = OffsitePaymentConverter.convert(fromAttribute: json["offsite"])
            payment = offsite.map(Payment.offsite)
        case "card"?, nil:
            offsite = nil
            card = json["card"].flatMap(Card.init(JSON:))
            payment = card.map(Payment.card)
        default:
            return nil
        }
        
        if let payment = payment {
            self.payment = payment
            self.card = card
            self.offsite = offsite
        } else {
            return nil
        }
    }
    
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
        case isAuthorized = "authrozed"
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
        chargeDescription = try container.decode(String.self, forKey: .chargeDescription)
        isAutoCapture = try container.decode(Bool.self, forKey: .isAutoCapture)
        isAuthorized = try container.decode(Bool.self, forKey: .isAuthorized)
        isPaid = try container.decode(Bool.self, forKey: .isPaid)
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
            let offsiteValue = try container.decode(String.self, forKey: .offsite)
            offsite = OffsitePaymentConverter.convert(fromAttribute: offsiteValue)
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
}


public struct ChargeParams: APIJSONQuery {
    public var customerID: String?
    public var cardID: String?
    public var value: Value
    public var chargeDescription: String?
    public var isAutoCapture: Bool?
    public var returnURL: URL?
    
    public var metadata: [String: Any]?
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "customer": customerID,
            "card": cardID,
            "amount": value.amount,
            "currency": value.currency.code,
            "description": chargeDescription,
            "capture": isAutoCapture,
            "return_uri": returnURL?.absoluteString,
            "metadata": metadata
            ])
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
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "description": chargeDescription,
            "metadata": metadata
            ])
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
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "created": DateComponentsConverter.convert(fromValue: created),
            "amount": amount,
            "captured": isCaptured,
            "authorized": isAuthorized,
            "card_last_digits": cardLastDigits?.lastDigits,
            "customer_present": isCustomerPresent,
            "failure_code": failureCode?.code,
            ])
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
    
    public init(JSON: [String : Any]) {
        self.init(
            created: JSON["created"].flatMap(DateComponentsConverter.convert(fromAttribute:)),
            amount: (JSON["amount"] as? Double),
            isAuthorized: (JSON["authorized"] as? Bool),
            isCaptured: (JSON["captured"] as? Bool),
            cardLastDigits: (JSON["card_last_digits"] as? String).flatMap(LastDigits.init(lastDigitsString:)),
            isCustomerPresent: JSON["customer_present"] as? Bool,
            failureCode: (JSON["failure_code"] as? String).flatMap(ChargeFailure.init(JSON:))
        )
    }
}

public struct ChargeSchedulingParameter: SchedulingParameter, APIJSONQuery {
    public let value: Value
    public let customerID: String
    public let cardID: String?
    public let chargeDescription: String?
    
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let value = Value(JSON: json),
            let customerID = json["customer"] as? String else {
                return nil
        }
        
        self.value = value
        self.customerID = customerID
        self.cardID = json["card"] as? String
        self.chargeDescription = json["description"] as? String
    }
    
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
        case chargeDescription = "descriptionf"
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
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "currency": value.currency.code,
            "amount": value.amount,
            "customer": customerID,
            "card": cardID ?? "",
            "description": chargeDescription,
            ])
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






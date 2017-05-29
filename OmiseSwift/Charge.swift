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
    public let value: Value
    
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
        self.value = value
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
}


public struct ChargeParams: APIParams {
    public var customerID: String?
    public var cardID: String?
    public var value: Value
    public var chargeDescription: String?
    public var isAutoCapture: Bool?
    public var returnURL: URL?
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "customer": customerID,
            "card": cardID,
            "amount": value.amount,
            "currency": value.currency.code,
            "description": chargeDescription,
            "capture": isAutoCapture,
            "return_uri": returnURL?.absoluteString,
            ])
    }
    
    public init(value: Value, chargeDescription: String? = nil, customerID: String? = nil, cardID: String? = nil, isAutoCapture: Bool? = nil, returnURL: URL? = nil) {
        self.value = value
        self.chargeDescription = chargeDescription
        self.customerID = customerID
        self.cardID = cardID
        self.isAutoCapture = isAutoCapture
        self.returnURL = returnURL
    }
}

public struct UpdateChargeParams: APIParams {
    public var chargeDescription: String?
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "description": chargeDescription,
            ])
    }
    
    public init(chargeDescription: String?) {
        self.chargeDescription = chargeDescription
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

public struct ChargeSchedulingParameter: SchedulingParameter {
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

extension Charge: Schedulable {
    public typealias Parameter = ChargeSchedulingParameter
}






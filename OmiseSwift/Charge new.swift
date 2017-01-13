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
    public let isDeleted: Bool
    
    public var chargeStatus: ChargeStatus
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
            let isAuthorized = json["authorized"] as? Bool, let isPaid = json["paid"] as? Bool,
            let status = ChargeStatus(JSON: json) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate, self.isDeleted) = omiseObjectProperties
        self.chargeStatus = status
        self.value = value
        self.isAuthorized = isAuthorized
        self.isAutoCapture = isAutoCapture
        self.isPaid = isPaid
        
        self.customer = json["customer"].flatMap(DetailProperty<Customer>.init(JSON:))
        self.transaction = json["transaction"].flatMap(DetailProperty<Transaction>.init(JSON:))
        
        self.ipAddress = json["ip"] as? String
        self.returnURL = (json["return_uri"] as? String).flatMap(URL.init(string:))
        self.authorizedURL = (json["authorized_uri"] as? String).flatMap(URL.init(string:))
        
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


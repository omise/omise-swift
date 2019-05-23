import Foundation


public struct ChargeSchedule: OmiseIdentifiableObject, OmiseCreatableObject, OmiseLiveModeObject {
    public let object: String
    public let id: String
    public let isLiveMode: Bool
    public let createdDate: Date
    
    public let customerID: String
    public let isDefaultCard: Bool
    public let cardID: String
    public let chargeDescription: String?
    public let amount: Int64
    public let currency: Currency
    
    public var value: Value {
        return Value(amount: amount, currency: currency)
    }
    
    private enum CodingKeys: String, CodingKey {
        case object
        case id
        case isLiveMode = "livemode"
        case createdDate = "created_at"
        case customerID = "customer"
        case isDefaultCard = "default_card"
        case cardID = "card"
        case chargeDescription = "description"
        case amount
        case currency
    }
}


extension Charge: Schedulable {
    public typealias ScheduleData = ChargeSchedule
    public typealias Parameter = ChargeSchedulingParameter
}

public struct ChargeSchedulingParameter: SchedulingParameter, APIJSONQuery {
    public var value: Value {
        return Value(amount: amount, currency: currency)
    }
    public var amount: Int64
    public var currency: Currency
    public let customerID: String
    public let cardID: String?
    public let chargeDescription: String?
    
    public init(value: Value, customerID: String, cardID: String?, description: String?) {
        self.amount = value.amount
        self.currency = value.currency
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
}

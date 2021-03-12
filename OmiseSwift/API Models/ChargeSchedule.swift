import Foundation

public struct ChargeSchedule: OmiseIdentifiableObject, OmiseCreatedObject, OmiseLiveModeObject {
    public static let idPrefix: String = "rchg"
    
    public let object: String
    public let id: DataID<ChargeSchedule>
    public let isLiveMode: Bool
    public let createdDate: Date
    
    public let customerID: DataID<Customer>
    public let isDefaultCard: Bool
    public let cardID: DataID<CustomerCard>
    public let chargeDescription: String?
    public let amount: Int64
    public let currency: Currency
    
    public var value: Value {
        return Value(amount: amount, currency: currency)
    }
}

extension ChargeSchedule {
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
    public let customerID: DataID<Customer>
    public let cardID: DataID<Card>?
    public let chargeDescription: String?
    
    public init(value: Value, customerID: DataID<Customer>, cardID: DataID<Card>?, description: String?) {
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

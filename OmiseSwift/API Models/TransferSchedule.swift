import Foundation



public struct TransferSchedule: OmiseIdentifiableObject, OmiseCreatedObject, OmiseLiveModeObject {
    public static let idPrefix: String = "rtrf"
    
    public let object: String
    public let id: DataID<TransferSchedule>
    public let isLiveMode: Bool
    public let createdDate: Date
    
    public let recipientID: DataID<Recipient>
    public let amount: TransferSchedulingParameter.Amount
}


extension TransferSchedule {
    private enum CodingKeys: String, CodingKey {
        case object
        case id
        case isLiveMode = "livemode"
        case createdDate = "created_at"
        
        case recipientID = "recipient"
        case percentageOfBalance = "percentage_of_balance"
        case amount
        case currency
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decode(String.self, forKey: .object)
        id = try container.decode(DataID<TransferSchedule>.self, forKey: .id)
        isLiveMode = try container.decode(Bool.self, forKey: .isLiveMode)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        
        recipientID = try container.decode(DataID<Recipient>.self, forKey: .recipientID)
        let percentageOfBalance = try container.decodeIfPresent(Double.self, forKey: .percentageOfBalance)
        let amount = try container.decodeIfPresent(Int64.self, forKey: .amount)
        let currency = try container.decodeIfPresent(Currency.self, forKey: .currency)
        
        switch (percentageOfBalance, amount, currency) {
        case (let percentageOfBalance?, nil, _) where 0.0...100 ~= percentageOfBalance:
            self.amount = .percentageOfBalance(percentageOfBalance)
        case (nil, let amount?, let currency?):
            self.amount = .value(Value(amount: amount, currency: currency))
        default:
            self.amount = .unknown
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(recipientID, forKey: .recipientID)
        switch amount {
        case .value(let value):
            try container.encode(value.amount, forKey: .amount)
            try container.encode(value.currency, forKey: .currency)
        case .percentageOfBalance(let percentage):
            try container.encode(percentage, forKey: .percentageOfBalance)
        case .unknown: break
        }
    }
}


extension Transfer: Schedulable {
    public typealias ScheduleData = TransferSchedule
    public typealias Parameter = TransferSchedulingParameter
}


public struct TransferSchedulingParameter: SchedulingParameter, APIJSONQuery, Equatable {
    public enum Amount: Equatable {
        case value(Value)
        case percentageOfBalance(Double)
        case unknown
    }
    
    public let recipientID: DataID<Recipient>
    public let amount: Amount
    
    private enum CodingKeys: String, CodingKey {
        case recipientID = "recipient"
        case percentageOfBalance = "percentage_of_balance"
        case amount
        case currency
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        recipientID = try container.decode(DataID<Recipient>.self, forKey: .recipientID)
        let percentageOfBalance = try container.decodeIfPresent(Double.self, forKey: .percentageOfBalance)
        let amount = try container.decodeIfPresent(Int64.self, forKey: .amount)
        let currency = try container.decodeIfPresent(Currency.self, forKey: .currency)
        
        switch (percentageOfBalance, amount, currency) {
        case (let percentageOfBalance?, nil, _) where 0.0...100 ~= percentageOfBalance:
            self.amount = .percentageOfBalance(percentageOfBalance)
        case (nil, let amount?, let currency?):
            self.amount = .value(Value(amount: amount, currency: currency))
        default:
            self.amount = .unknown
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(recipientID, forKey: .recipientID)
        switch amount {
        case .value(let value):
            try container.encode(value.amount, forKey: .amount)
            try container.encode(value.currency, forKey: .currency)
        case .percentageOfBalance(let percentage):
            try container.encode(percentage, forKey: .percentageOfBalance)
        case .unknown: break
        }
    }
}


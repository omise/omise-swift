import Foundation


public enum TransferStatus {
    case pending
    case paid
    case sent
    case failed(TransferFailure)
}


public struct Transfer: OmiseResourceObject, Equatable {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/transfers")
    
    public let object: String
    public let location: String
    
    public let id: String
    public let isLive: Bool
    public var createdDate: Date
    
    public var status: TransferStatus
    public let shouldFailFast: Bool
    
    public let bankAccount: BankAccount
    
    public let isSent: Bool
    public let sentDate: Date?
    public let isPaid: Bool
    public let paidDate: Date?
    
    public var value: Value {
        return Value(amount: amount, currency: currency)
    }
    
    public var feeValue: Value {
        return Value(amount: fee, currency: currency)
    }
    
    public let amount: Int64
    public let fee: Int64
    public let currency: Currency
        
    public let recipient: DetailProperty<Recipient>
    public let transaction: DetailProperty<Transaction<Transfer>>?
    
    public let metadata: JSONDictionary
    
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case isLive = "livemode"
        case createdDate = "created"
        case bankAccount = "bank_account"
        case shouldFailFast = "fail_fast"
        case fee
        case amount
        case currency
        case isSent = "sent"
        case isPaid = "paid"
        case sentDate = "sent_at"
        case paidDate = "paid_at"
        case recipient
        case transaction
        case failureCode = "failure_code"
        case metadata
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decode(String.self, forKey: .object)
        location = try container.decode(String.self, forKey: .location)
        id = try container.decode(String.self, forKey: .id)
        isLive = try container.decode(Bool.self, forKey: .isLive)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        bankAccount = try container.decode(BankAccount.self, forKey: .bankAccount)
        shouldFailFast = try container.decode(Bool.self, forKey: .shouldFailFast)
        fee = try container.decode(Int64.self, forKey: .fee)
        amount = try container.decode(Int64.self, forKey: .amount)
        currency = try container.decode(Currency.self, forKey: .currency)
        isSent = try container.decode(Bool.self, forKey: .isSent)
        isPaid = try container.decode(Bool.self, forKey: .isPaid)
        sentDate = try container.decodeIfPresent(Date.self, forKey: .sentDate)
        paidDate = try container.decodeIfPresent(Date.self, forKey: .paidDate)
        recipient = try container.decode(DetailProperty<Recipient>.self, forKey: .recipient)
        transaction = try container.decodeIfPresent(DetailProperty<Transaction>.self, forKey: .transaction)
        
        let failureCode = try container.decodeIfPresent(TransferFailure.self, forKey: .failureCode)
        switch (isPaid, isSent, failureCode) {
        case (_, _, let failure?):
            self.status = .failed(failure)
        case (true, true, nil):
            self.status = .paid
        case (false, true, nil):
            self.status = .sent
        default:
            self.status = .pending
        }
        
        metadata = try container.decode(JSONDictionary.self, forKey: .metadata)
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
        try container.encode(fee, forKey: .fee)
        try container.encode(bankAccount, forKey: .bankAccount)
        try container.encode(shouldFailFast, forKey: .shouldFailFast)
        
        try container.encode(isSent, forKey: .isSent)
        try container.encode(isPaid, forKey: .isPaid)
        try container.encodeIfPresent(sentDate, forKey: .sentDate)
        try container.encodeIfPresent(paidDate, forKey: .paidDate)
        try container.encode(recipient, forKey: .recipient)
        try container.encodeIfPresent(transaction, forKey: .transaction)
        try container.encode(metadata, forKey: .metadata)
        
        if case .failed(let failureCode) = status {
            try container.encode(failureCode, forKey: .failureCode)
        }
    }
}


public struct TransferParams: APIJSONQuery {
    public var amount: Int64
    public var recipientID: String?
    public var failFast: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case amount
        case recipientID = "recipient"
        case failFast = "fail_fast"
    }
    
    public init(amount: Int64, recipientID: String? = nil, failFast: Bool? = nil) {
        self.amount = amount
        self.recipientID = recipientID
        self.failFast = failFast
    }
}

public struct UpdateTransferParams: APIJSONQuery {
    public var amount: Int64
    
    public init(amount: Int64) {
        self.amount = amount
    }
}


public struct TransferFilterParams: OmiseFilterParams {
    public var created: DateComponents?
    public var amount: Double?
    public var currency: Currency?
    public var bankLastDigits: LastDigits?
    public var fee: Double?
    public var isPaid: Bool?
    public var paidDate: DateComponents?
    public var isSent: Bool?
    public var sentDate: DateComponents?
    public var failureCode: String?
    public var failureMessage: String?
    
    private enum CodingKeys: String, CodingKey {
        case created
        case amount
        case currency
        case bankLastDigits = "bank_last_digits"
        case fee
        case isPaid = "paid"
        case paidDate = "paid_at"
        case isSent = "sent"
        case sentDate = "sent_at"
        case failureCode = "failure_code"
        case failureMessage = "failure_message"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        created = try container.decodeOmiseDateComponentsIfPresent(forKey: .created)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        currency = try container.decodeIfPresent(Currency.self, forKey: .currency)
        bankLastDigits = try container.decodeIfPresent(LastDigits.self, forKey: .bankLastDigits)
        fee = try container.decodeIfPresent(Double.self, forKey: .fee)
        isPaid = try container.decodeIfPresent(Bool.self, forKey: .isPaid)
        paidDate = try container.decodeOmiseDateComponentsIfPresent(forKey: .paidDate)
        isSent = try container.decodeIfPresent(Bool.self, forKey: .isSent)
        sentDate = try container.decodeOmiseDateComponentsIfPresent(forKey: .sentDate)
        failureCode = try container.decodeIfPresent(String.self, forKey: .failureCode)
        failureMessage = try container.decodeIfPresent(String.self, forKey: .failureMessage)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeOmiseDateComponentsIfPresent(created, forKey: .created)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(currency, forKey: .currency)
        try container.encodeIfPresent(bankLastDigits, forKey: .bankLastDigits)
        try container.encodeIfPresent(fee, forKey: .fee)
        try container.encodeIfPresent(isPaid, forKey: .isPaid)
        try container.encodeOmiseDateComponentsIfPresent(paidDate, forKey: .paidDate)
        try container.encodeIfPresent(isSent, forKey: .isSent)
        try container.encodeOmiseDateComponentsIfPresent(sentDate, forKey: .sentDate)
        try container.encodeIfPresent(failureCode, forKey: .failureCode)
        try container.encodeIfPresent(failureMessage, forKey: .failureMessage)
    }
    
    public init(created: DateComponents? = nil, amount: Double? = nil, currency: Currency? = nil,
                bankLastDigits: LastDigits? = nil, fee: Double? = nil,
                isPaid: Bool? = nil, paidDate: DateComponents? = nil,
                isSent: Bool? = nil, sentDate: DateComponents? = nil,
                failureCode: String? = nil, failureMessage: String? = nil) {
        self.created = created
        self.amount = amount
        self.currency = currency
        self.bankLastDigits = bankLastDigits
        self.fee = fee
        self.isPaid = isPaid
        self.paidDate = paidDate
        self.isSent = isSent
        self.sentDate = sentDate
        self.failureCode = failureCode
        self.failureMessage = failureMessage
    }
}

public struct TransferSchedulingParameter: SchedulingParameter, Equatable {
    public enum Amount: Equatable {
        case value(Value)
        case percentageOfBalance(Double)
        case unknown
    }
    
    public let recipientID: String
    public let amount: Amount
    
    private enum CodingKeys: String, CodingKey {
        case recipientID = "recipient"
        case percentageOfBalance = "percentage_of_balance"
        case amount
        case currency
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        recipientID = try container.decode(String.self, forKey: .recipientID)
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

extension Transfer: Listable {}
extension Transfer: Retrievable {}

extension Transfer: Creatable {
    public typealias CreateParams = TransferParams
}

extension Transfer: Updatable {
    public typealias UpdateParams = UpdateTransferParams
}

extension Transfer: Destroyable {}

extension Transfer: Searchable {
    public typealias FilterParams = TransferFilterParams
}

extension Transfer: Schedulable {
    public typealias Parameter = TransferSchedulingParameter
}


import Foundation


public struct Transfer: OmiseResourceObject, Equatable {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/transfers")
    
    public let object: String
    public let location: String
    
    public let id: String
    public let isLiveMode: Bool
    public let isDeleted: Bool
    public var createdDate: Date
    
    public var status: Status
    public let shouldFailFast: Bool
    
    public let bankAccount: BankAccount
    
    public let isSent: Bool
    public let sentDate: Date?
    public let isPaid: Bool
    public let paidDate: Date?
    public let isSendable: Bool
    
    public let amount: Int64
    public var value: Value {
        return Value(amount: amount, currency: currency)
    }
    
    public let fee: Int64
    public var feeValue: Value {
        return Value(amount: fee, currency: currency)
    }
    
    public let feeVat: Int64
    public var feeVatValue: Value {
        return Value(amount: feeVat, currency: currency)
    }
    
    public let net: Int64
    public var netValue: Value {
        return Value(amount: net, currency: currency)
    }
    
    public let totalFee: Int64
    public var totalFeeValue: Value {
        return Value(amount: totalFee, currency: currency)
    }
    
    public let currency: Currency
    
    public let recipient: DetailProperty<Recipient>
    public let transactions: [Transaction<Transfer>]
    
    public let metadata: JSONDictionary
    
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case isLiveMode = "livemode"
        case isDeleted = "deleted"
        case createdDate = "created_at"
        case bankAccount = "bank_account"
        case shouldFailFast = "fail_fast"
        case isSent = "sent"
        case isPaid = "paid"
        case sentDate = "sent_at"
        case paidDate = "paid_at"
        case isSendable = "sendable"
        case amount
        case fee
        case feeVat = "fee_vat"
        case net
        case totalFee = "total_fee"
        case currency
        case recipient
        case transactions
        case failureCode = "failure_code"
        case failureMessage = "failure_message"
        case metadata
    }
    
    public enum Status {
        case pending
        case paid
        case sent
        case failed(TransferFailure)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decode(String.self, forKey: .object)
        location = try container.decode(String.self, forKey: .location)
        id = try container.decode(String.self, forKey: .id)
        isLiveMode = try container.decode(Bool.self, forKey: .isLiveMode)
        isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        shouldFailFast = try container.decode(Bool.self, forKey: .shouldFailFast)
        bankAccount = try container.decode(BankAccount.self, forKey: .bankAccount)
        isSent = try container.decode(Bool.self, forKey: .isSent)
        isPaid = try container.decode(Bool.self, forKey: .isPaid)
        sentDate = try container.decodeIfPresent(Date.self, forKey: .sentDate)
        paidDate = try container.decodeIfPresent(Date.self, forKey: .paidDate)
        isSendable = try container.decode(Bool.self, forKey: .isSendable)
        fee = try container.decode(Int64.self, forKey: .fee)
        amount = try container.decode(Int64.self, forKey: .amount)
        currency = try container.decode(Currency.self, forKey: .currency)
        feeVat = try container.decode(Int64.self, forKey: .feeVat)
        net = try container.decode(Int64.self, forKey: .net)
        totalFee = try container.decode(Int64.self, forKey: .totalFee)
        recipient = try container.decode(DetailProperty<Recipient>.self, forKey: .recipient)
        transactions = try container.decode(Array<Transaction<Transfer>>.self, forKey: .transactions)
        
        let failureCode = try container.decodeIfPresent(TransferFailure.Code.self, forKey: .failureCode)
        let failureMessage = try container.decodeIfPresent(String.self, forKey: .failureMessage)
        switch (isPaid, isSent, failureCode, failureMessage) {
        case (_, _, let failureCode?, let failureMessage?):
            self.status = .failed(TransferFailure(code: failureCode, message: failureMessage))
        case (true, true, nil, nil):
            self.status = .paid
        case (false, true, nil, nil):
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
        try container.encode(isLiveMode, forKey: .isLiveMode)
        
        
        try container.encode(shouldFailFast, forKey: .shouldFailFast)
        try container.encode(bankAccount, forKey: .bankAccount)
        try container.encode(isDeleted, forKey: .isDeleted)
        try container.encode(isSent, forKey: .isSent)
        try container.encode(isPaid, forKey: .isPaid)
        try container.encodeIfPresent(sentDate, forKey: .sentDate)
        try container.encodeIfPresent(paidDate, forKey: .paidDate)
        try container.encode(isSendable, forKey: .isSendable)
        
        try container.encode(amount, forKey: .amount)
        try container.encode(fee, forKey: .fee)
        try container.encode(feeVat, forKey: .feeVat)
        try container.encode(net, forKey: .net)
        try container.encode(totalFee, forKey: .totalFee)
        try container.encode(currency, forKey: .currency)
        
        try container.encode(recipient, forKey: .recipient)
        try container.encode(transactions, forKey: .transactions)
        try container.encode(metadata, forKey: .metadata)
        
        if case .failed(let failure) = status {
            try container.encode(failure.code, forKey: .failureCode)
            try container.encode(failure.message, forKey: .failureMessage)
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
    public var amount: Double?
    public var created: DateComponents?
    public var isDeleted: Bool?
    public var fee: Double?
    public var isPaid: Bool?
    public var paidDate: DateComponents?
    public var isSent: Bool?
    public var sentDate: DateComponents?
    
    private enum CodingKeys: String, CodingKey {
        case amount
        case created
        case currency
        case isDeleted = "deleted"
        case fee
        case isPaid = "paid"
        case paidDate = "paid_at"
        case isSent = "sent"
        case sentDate = "sent_at"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decodeOmiseAPIValueIfPresent(Double.self, forKey: .amount)
        created = try container.decodeOmiseDateComponentsIfPresent(forKey: .created)
        isDeleted = try container.decodeOmiseAPIValueIfPresent(Bool.self, forKey: .isDeleted)
        fee = try container.decodeOmiseAPIValueIfPresent(Double.self, forKey: .fee)
        isPaid = try container.decodeOmiseAPIValueIfPresent(Bool.self, forKey: .isPaid)
        paidDate = try container.decodeOmiseDateComponentsIfPresent(forKey: .paidDate)
        isSent = try container.decodeOmiseAPIValueIfPresent(Bool.self, forKey: .isSent)
        sentDate = try container.decodeOmiseDateComponentsIfPresent(forKey: .sentDate)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeOmiseDateComponentsIfPresent(created, forKey: .created)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(isDeleted, forKey: .isDeleted)
        try container.encodeIfPresent(fee, forKey: .fee)
        try container.encodeIfPresent(isPaid, forKey: .isPaid)
        try container.encodeOmiseDateComponentsIfPresent(paidDate, forKey: .paidDate)
        try container.encodeIfPresent(isSent, forKey: .isSent)
        try container.encodeOmiseDateComponentsIfPresent(sentDate, forKey: .sentDate)
    }
    
    public init(amount: Double? = nil, created: DateComponents? = nil,
                currency: Currency? = nil, isDeleted: Bool? = nil,
                bankLastDigits: Digits? = nil, fee: Double? = nil,
                isPaid: Bool? = nil, paidDate: DateComponents? = nil,
                isSent: Bool? = nil, sentDate: DateComponents? = nil) {
        self.amount = amount
        self.created = created
        self.isDeleted = isDeleted
        self.fee = fee
        self.isPaid = isPaid
        self.paidDate = paidDate
        self.isSent = isSent
        self.sentDate = sentDate
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


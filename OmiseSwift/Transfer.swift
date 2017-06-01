import Foundation


public enum TransferStatus {
    case pending
    case paid
    case sent
    case failed(TransferFailure)
}


public struct Transfer: OmiseResourceObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/transfers")
    
    public let object: String
    public let location: String
    
    public let id: String
    public let isLive: Bool
    public var createdDate: Date
    
    public var status: TransferStatus
    public let failFast: Bool
    
    public let bankAccount: BankAccount
    
    public let isSent: Bool
    public let sentDate: Date?
    public let isPaid: Bool
    public let paidDate: Date?
    
    public let value: Value
    public let fee: Value
    
    public let recipient: DetailProperty<Recipient>
    public let transaction: DetailProperty<Transaction>?
}


extension Transfer {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Transfer.parseOmiseResource(JSON: json) else {
                return nil
        }
        
        guard let bankAccount = json["bank_account"].flatMap(BankAccount.init(JSON:)),
            let value = Value(JSON: json),
            let fee = json["fee"] as? Int64, let currency = json["currency"].flatMap(CurrencyFieldConverter.convert(fromAttribute:)),
            let isSent = json["sent"] as? Bool, let isPaid = json["paid"] as? Bool,
            let recipient = json["recipient"].flatMap(DetailProperty<Recipient>.init(JSON:)) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate) = omiseObjectProperties
        self.bankAccount = bankAccount
        self.isSent = isSent
        self.isPaid = isPaid
        self.value = value
        self.fee = Value(amount: fee, currency: currency)
        self.recipient = recipient
        
        self.transaction = json["transaction"].flatMap(DetailProperty<Transaction>.init(JSON:))
        self.sentDate = json["sent_at"].flatMap(DateConverter.convert(fromAttribute:))
        self.paidDate = json["paid_at"].flatMap(DateConverter.convert(fromAttribute:))
        
        let failure = (json["failure_code"] as? String).flatMap(TransferFailure.init(code:))
        switch (isPaid, isSent, failure) {
        case (_, _, let failure?):
            self.status = .failed(failure)
        case (true, true, nil):
            self.status = .paid
        case (false, true, nil):
            self.status = .sent
        default:
            self.status = .pending
        }
        
        self.failFast = json["fail_fast"] as? Bool ?? false
    }
}


public struct TransferParams: APIParams {
    public var amount: Int64
    public var recipientID: String?
    public var failFast: Bool?
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "amount": amount,
            "recipient": recipientID,
            "fail_fast": failFast,
            ])
    }
    
    public init(amount: Int64, recipientID: String? = nil, failFast: Bool? = nil) {
        self.amount = amount
        self.recipientID = recipientID
        self.failFast = failFast
    }
}

public struct UpdateTransferParams: APIParams {
    public var amount: Int64
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "amount": amount,
            ])
    }
    
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
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "created": DateComponentsConverter.convert(fromValue: created),
            "amount": amount,
            "currency": currency?.code,
            "bank_last_digits": bankLastDigits?.lastDigits,
            "fee": fee,
            "paid": isPaid,
            "paid_at": DateComponentsConverter.convert(fromValue: paidDate),
            "sent": isSent,
            "sent_at": DateComponentsConverter.convert(fromValue: sentDate),
            "failure_code": failureCode,
            "failure_message": failureMessage,
            ])
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
    
    public init(JSON: [String : Any]) {
        self.init(
            created: JSON["created"].flatMap(DateComponentsConverter.convert(fromAttribute:)),
            amount: (JSON["amount"] as? Double),
            currency: (JSON["currency"] as? String).flatMap(Currency.init(code:)),
            bankLastDigits: (JSON["bank_last_digits"] as? String).flatMap(LastDigits.init(lastDigitsString:)),
            fee: (JSON["fee"] as? Double),
            isPaid: JSON["paid"] as? Bool,
            paidDate: JSON["paid_at"].flatMap(DateComponentsConverter.convert(fromAttribute:)),
            isSent: JSON["sent"] as? Bool,
            sentDate: JSON["sent_at"].flatMap(DateComponentsConverter.convert(fromAttribute:)),
            failureCode: JSON["failure_code"] as? String,
            failureMessage: JSON["failure_message"] as? String
        )
    }
}

public struct TransferSchedulingParameter: SchedulingParameter, Equatable {
    public enum Amount {
        case value(Value)
        case percentageOfBalance(Int)
    }
    
    public let recipientID: String
    public let amount: Amount
    
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let recipientID = json["recipient"] as? String else {
                return nil
        }
        
        let value = Value(JSON: json)
        let percentageOfBalance = json["percentage_of_balance"] as? Int
        
        let amount: Amount
        switch (percentageOfBalance, value) {
        case (let percentage?, nil) where 1...100 ~= percentage:
            amount = .percentageOfBalance(percentage)
        case (nil, let value?):
            amount = .value(value)
        default:
            return nil
        }
        
        self.amount = amount
        self.recipientID = recipientID
    }
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: TransferSchedulingParameter, rhs: TransferSchedulingParameter) -> Bool {
        return lhs.amount == rhs.amount && lhs.recipientID == rhs.recipientID
    }
}

extension TransferSchedulingParameter.Amount: Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: TransferSchedulingParameter.Amount, rhs: TransferSchedulingParameter.Amount) -> Bool {
        switch (lhs, rhs) {
        case (.value(let lhsValue), .value(let rhsValue)):
            return lhsValue == rhsValue
        case (.percentageOfBalance(let lhsPercentage), .percentageOfBalance(let rhsPercentage)):
            return lhsPercentage == rhsPercentage
        default:
            return false
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


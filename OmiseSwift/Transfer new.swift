import Foundation

public struct Transfer: OmiseResourceObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/transfers")
    
    public let object: String
    public let location: String
    
    public let id: String
    public let isLive: Bool
    public var createdDate: Date
    public let isDeleted: Bool
    
    public let bankAccount: BankAccount
    
    public let isSent: Bool
    public let sentDate: Date?
    public let isPaid: Bool
    public let paidDate: Date?
    
    public let value: Value
    public let fee: Value

    public let transaction: DetailProperty<Transaction>?
}


extension Transfer {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Charge.parseOmiseResource(JSON: json) else {
                return nil
        }

        guard let bankAccount = json["bank_account"].flatMap(BankAccount.init(JSON:)),
            let value = Value(JSON: json),
            let fee = json["fee"] as? Int64, let currency = json["currency"].flatMap(CurrencyFieldConverter.convert(fromAttribute:)),
            let isSent = json["sent"] as? Bool, let isPaid = json["paid"] as? Bool else {
                return nil
        }
            
        (self.object, self.location, self.id, self.isLive, self.createdDate, self.isDeleted) = omiseObjectProperties
        self.bankAccount = bankAccount
        self.isSent = isSent
        self.isPaid = isPaid
        self.value = value
        self.fee = Value(currency: currency, amount: fee)
        
        self.transaction = json["transaction"].flatMap(DetailProperty<Transaction>.init(JSON:))
        self.sentDate = json["sent_at"].flatMap(DateConverter.convert(fromAttribute:))
        self.paidDate = json["paid_at"].flatMap(DateConverter.convert(fromAttribute:))
    }
}


public struct TransferParams: APIParams {
    public var amount: Int64
    
    public var recipientID: String
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "amount": amount,
            "recipient": recipientID,
            ])
    }
}

public struct UpdateTransferParams: APIParams {
    public var amount: Int64
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "amount": amount,
            ])
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
}


extension Transfer: Listable { }
extension Transfer: Retrievable { }

extension Transfer: Creatable {
    public typealias CreateParams = TransferParams
}

extension Transfer: Updatable {
    public typealias UpdateParams = UpdateTransferParams
}

extension Transfer: Destroyable { }

extension Transfer: Searchable {
    public typealias FilterParams = TransferFilterParams
}


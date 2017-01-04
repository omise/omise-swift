import Foundation

public class Transfer: ResourceObject {
    public override class var info: ResourceInfo { return ResourceInfo(path: "/transfers") }
    
    public var recipient: String? {
        get { return get("recipient", StringConverter.self) ?? getChild("recipient", Recipient.self)?.id }
        set { set("recipient", StringConverter.self, toValue: newValue) }
    }
    
    public var bankAccount: BankAccount? {
        get { return getChild("bank_account", BankAccount.self) }
        set { setChild("bank_account", BankAccount.self, toValue: newValue) }
    }
    
    public var sent: Bool? {
        get { return get("sent", BoolConverter.self) }
        set { set("sent", BoolConverter.self, toValue: newValue) }
    }

    public var paid: Bool? {
        get { return get("paid", BoolConverter.self) }
        set { set("paid", BoolConverter.self, toValue: newValue) }
    }
    
    public var sentDate: Date? {
        get { return get("sent_at", DateConverter.self) }
        set { set("sent_at", DateConverter.self, toValue: newValue) }
    }
    
    public var paidDate: Date? {
        get { return get("paid_at", DateConverter.self) }
        set { set("paid_at", DateConverter.self, toValue: newValue) }
    }

    public var amount: Int64? {
        get { return get("amount", Int64Converter.self) }
        set { set("amount", Int64Converter.self, toValue: newValue) }
    }
    
    public var fee: Int64? {
        get { return get("fee", Int64Converter.self) }
        set { set("fee", Int64Converter.self, toValue: newValue) }
    }
    
    public var currency: Currency? {
        get { return get("currency", StringConverter.self).flatMap(Currency.init(code:)) }
        set { set("currency", StringConverter.self, toValue: newValue?.code) }
    }
    
    public var failureCode: String? {
        get { return get("failure_code", StringConverter.self) }
        set { set("failure_code", StringConverter.self, toValue: newValue) }
    }
    
    public var failureMessage: String? {
        get { return get("failure_message", StringConverter.self) }
        set { set("failure_message", StringConverter.self, toValue: newValue) }
    }
    
    public var transaction: String? {
        get { return get("transaction", StringConverter.self) ?? getChild(("transaction"), Transaction.self)?.id }
        set { set("transaction", StringConverter.self, toValue: newValue) }
    }
}

public class TransferParams: Params {
    public var amount: Int64? {
        get { return get("amount", Int64Converter.self) }
        set { set("amount", Int64Converter.self, toValue: newValue) }
    }
    
    public var recipient: String? {
        get { return get("recipient", StringConverter.self) }
        set { set("recipient", StringConverter.self, toValue: newValue) }
    }
}


public class TransferFilterParams: OmiseFilterParams {
    public var created: DateComponents? {
        get { return get("created", DateComponentsConverter.self) }
        set { set("created", DateComponentsConverter.self, toValue: newValue) }
    }
    public var amount: Double? {
        get { return get("amount", DoubleConverter.self) }
        set { set("amount", DoubleConverter.self, toValue: newValue) }
    }
    
    public var currency: Currency? {
        get { return get("currency", CurrencyFieldConverter.self) }
        set { set("currency", CurrencyFieldConverter.self, toValue: newValue) }
    }
    
    public var bankLastDigits: String? {
        get { return get("bank_last_digits", StringConverter.self) }
        set { set("bank_last_digits", StringConverter.self, toValue: newValue) }
    }
    
    public var fee: Double? {
        get { return get("fee", DoubleConverter.self) }
        set { set("fee", DoubleConverter.self, toValue: newValue) }
    }
    
    public var paid: Bool? {
        get { return get("paid", BoolConverter.self) }
        set { set("paid", BoolConverter.self, toValue: newValue) }
    }
    
    public var paidDate: DateComponents? {
        get { return get("paid_at", DateComponentsConverter.self) }
        set { set("paid_at", DateComponentsConverter.self, toValue: newValue) }
    }
    
    public var sent: Bool? {
        get { return get("sent", BoolConverter.self) }
        set { set("sent", BoolConverter.self, toValue: newValue) }
    }
    
    public var sentDate: DateComponents? {
        get { return get("sent_at", DateComponentsConverter.self) }
        set { set("sent_at", DateComponentsConverter.self, toValue: newValue) }
    }
    
    public var failureCode: String? {
        get { return get("failure_code", StringConverter.self) }
        set { set("failure_code", StringConverter.self, toValue: newValue) }
    }
    
    public var failureMessage: String? {
        get { return get("failure_message", StringConverter.self) }
        set { set("failure_message", StringConverter.self, toValue: newValue) }
    }
}


extension Transfer: Listable { }
extension Transfer: Retrievable { }

extension Transfer: Creatable {
    public typealias CreateParams = TransferParams
}

extension Transfer: Updatable {
    public typealias UpdateParams = TransferParams
}

extension Transfer: Destroyable { }

extension Transfer: Searchable {
    public typealias FilterParams = TransferFilterParams
}


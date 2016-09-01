import Foundation

public class Transaction: ResourceObject {
    public override class var info: ResourceInfo { return ResourceInfo(path: "/transactions") }
    
    public var type: TransactionType? {
        get { return get("type", EnumConverter<TransactionType>.self) }
        set { set("type", EnumConverter<TransactionType>.self, toValue: newValue) }
    }
    
    public var amount: Int64? {
        get { return get("amount", Int64Converter.self) }
        set { set("amount", Int64Converter.self, toValue: newValue) }
    }
    
    public var currency: Currency? {
        get { return get("currency", StringConverter.self).flatMap(Currency.init(code:)) }
        set { set("currency", StringConverter.self, toValue: newValue?.code) }
    }
}

extension Transaction: Listable { }
extension Transaction: Retrievable { }
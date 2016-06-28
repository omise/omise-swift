import Foundation

public class Transaction: ResourceObject {
    public override class var resourcePath: String { return "/transactions" }
    
    public var type: TransactionType? {
        get { return get("type", EnumConverter<TransactionType>.self) }
        set { set("type", EnumConverter<TransactionType>.self, toValue: newValue) }
    }
    
    public var amount: Int64? {
        get { return get("amount", Int64Converter.self) }
        set { set("amount", Int64Converter.self, toValue: newValue) }
    }
    
    public var currency: String? {
        get { return get("currency", StringConverter.self) }
        set { set("currency", StringConverter.self, toValue: newValue) }
    }
}

extension Transaction: Listable { }
extension Transaction: InstanceRetrievable { }
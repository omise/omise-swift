import Foundation

public class Charge: ResourceObject {
    public var status: ChargeStatus? {
        get { return get("status", EnumConverter.self) }
        set { set("status", EnumConverter.self, toValue: newValue) }
    }
    
    public var amount: Int64? {
        get { return get("amount", Int64Converter.self) }
        set { set("amount", Int64Converter.self, toValue: newValue) }
    }
    
    public var currency: String? {
        get { return get("currency", StringConverter.self) }
        set { set("currency", StringConverter.self, toValue: newValue) }
    }
    
    public var chargeDescription: String? {
        get { return get("description", StringConverter.self) }
        set { set("description", StringConverter.self, toValue: newValue) }
    }
    
    public var capture: Bool? {
        get { return get("capture", BoolConverter.self) }
        set { set("capture", BoolConverter.self, toValue: newValue) }
    }
    
    public var authorized: Bool? {
        get { return get("authorized", BoolConverter.self) }
        set { set("authorized", BoolConverter.self, toValue: newValue) }
    }
    
    public var paid: Bool? {
        get { return get("paid", BoolConverter.self) }
        set { set("paid", BoolConverter.self, toValue: newValue) }
    }
    
    public var transaction: String? {
        get { return get("transaction", StringConverter.self) }
        set { set("transaction", StringConverter.self, toValue: newValue) }
    }
    
    public var card: Card? {
        get { return getChild("card", Card.self) }
        set { setChild("card", Card.self, toValue: newValue) }
    }
    
    public var refunded: Int64? {
        get { return get("refunded", Int64Converter.self) }
        set { set("refunded", Int64Converter.self, toValue: newValue) }
    }
    
    public var refunds: OmiseList<Refund>? {
        get { return getChild("refunds", OmiseList<Refund>.self) }
        set { setChild("refunds", OmiseList<Refund>.self, toValue: newValue) }
    }
    
    public var failureCode: String? {
        get { return get("failure_code", StringConverter.self) }
        set { set("failure_code", StringConverter.self, toValue: newValue) }
    }
    
    public var failureMessage: String? {
        get { return get("failure_message", StringConverter.self) }
        set { set("failure_message", StringConverter.self, toValue: newValue) }
    }
    
    public var customer: String? {
        get { return get("customer", StringConverter.self) }
        set { set("customer", StringConverter.self, toValue: newValue) }
    }
    
    public var ip: String? {
        get { return get("ip", StringConverter.self) }
        set { set("ip", StringConverter.self, toValue: newValue) }
    }
    
    // TODO: Dispute (nested model)
    
    public var returnUri: String? {
        get { return get("return_uri", StringConverter.self) }
        set { set("return_uri", StringConverter.self, toValue: newValue) }
    }
    
    public var authorizeUri: String? {
        get { return get("authorize_uri", StringConverter.self) }
        set { set("authorize_uri", StringConverter.self, toValue: newValue) }
    }
}

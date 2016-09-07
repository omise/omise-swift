import Foundation

public class Recipient: ResourceObject {
    public override class var info: ResourceInfo { return ResourceInfo(path: "/recipients") }
    
    public var verified: Bool? {
        get { return get("verified", BoolConverter.self) }
        set { set("verified", BoolConverter.self, toValue: newValue) }
    }
    
    public var active: Bool? {
        get { return get("active", BoolConverter.self) }
        set { set("active", BoolConverter.self, toValue: newValue) }
    }
    
    public var name: String? {
        get { return get("name", StringConverter.self) }
        set { set("name", StringConverter.self, toValue: newValue) }
    }
    
    public var email: String? {
        get { return get("email", StringConverter.self) }
        set { set("email", StringConverter.self, toValue: newValue) }
    }
    
    public var recipientDescription: String? {
        get { return get("description", StringConverter.self) }
        set { set("description", StringConverter.self, toValue: newValue) }
    }
    
    public var type: RecipientType? {
        get { return get("type", EnumConverter.self) }
        set { set("type", EnumConverter.self, toValue: newValue) }
    }
    
    public var taxId: String? {
        get { return get("tax_id", StringConverter.self) }
        set { set("tax_id", StringConverter.self, toValue: newValue) }
    }
    
    public var bankAccount: BankAccount? {
        get { return getChild("bank_account", BankAccount.self) }
        set { setChild("bank_account", BankAccount.self, toValue: newValue) }
    }
    
    public var failureCode: String? {
        get { return get("failure_code", StringConverter.self) }
        set { set("failure_code", StringConverter.self, toValue: newValue) }
    }
}

public class RecipientParams: Params {
    public var name: String? {
        get { return get("name", StringConverter.self) }
        set { set("name", StringConverter.self, toValue: newValue) }
    }
    
    public var email: String? {
        get { return get("email", StringConverter.self) }
        set { set("email", StringConverter.self, toValue: newValue) }
    }
    
    public var description: String? {
        get { return get("description", StringConverter.self) }
        set { set("description", StringConverter.self, toValue: newValue) }
    }
    
    public var type: RecipientType? {
        get { return get("type", EnumConverter.self) }
        set { set("type", EnumConverter.self, toValue: newValue) }
    }
    
    public var taxId: String? {
        get { return get("tax_id", StringConverter.self) }
        set { set("tax_id", StringConverter.self, toValue: newValue) }
    }
    
    public var bankAccount: BankAccount? {
        get { return getChild("bank_account", BankAccount.self) }
        set { setChild("bank_account", BankAccount.self, toValue: newValue) }
    }
}

public class RecipientFilterParams: OmiseFilterParams {
    public var type: RecipientType? {
        get { return get("kind", EnumConverter.self) }
        set { set("kind", EnumConverter.self, toValue: newValue) }
    }
}

extension Recipient: Listable { }
extension Recipient: Retrievable { }

extension Recipient: Creatable {
    public typealias CreateParams = RecipientParams
}

extension Recipient: Updatable {
    public typealias UpdateParams = RecipientParams
}

extension Recipient: Searchable {
    public typealias FilterParams = RecipientFilterParams
}

extension Recipient: Destroyable { }
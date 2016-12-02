import Foundation


public class Link: ResourceObject {
    public override class var info: ResourceInfo { return ResourceInfo(path: "/links") }
    
    public var amount: Int64? {
        get { return get("amount", Int64Converter.self) }
        set { set("amount", Int64Converter.self, toValue: newValue) }
    }
    
    public var currency: Currency? {
        get { return get("currency", StringConverter.self).flatMap(Currency.init(code:)) }
        set { set("currency", StringConverter.self, toValue: newValue?.code) }
    }
    
    public var isUsed: Bool? {
        get { return get("used", BoolConverter.self) }
        set { set("used", BoolConverter.self, toValue: newValue) }
    }
    
    public var isMultiple: Bool? {
        get { return get("multiple", BoolConverter.self) }
        set { set("multiple", BoolConverter.self, toValue: newValue) }
    }

    public var title: String? {
        get { return get("title", StringConverter.self) }
        set { set("title", StringConverter.self, toValue: newValue) }
    }
    
    public var linkDescription: String? {
        get { return get("description", StringConverter.self) }
        set { set("description", StringConverter.self, toValue: newValue) }
    }
    
    public var charges: OmiseList<Charge>? {
        get { return getChild("charges", OmiseList<Charge>.self) }
        set { setChild("charges", OmiseList<Charge>.self, toValue: newValue) }
    }
    public var paymentURL: String? {
        get { return get("payment_uri", StringConverter.self) }
        set { set("payment_uri", StringConverter.self, toValue: newValue) }
    }
}

public class LinkParams: Params {
    public var amount: Int64? {
        get { return get("amount", Int64Converter.self) }
        set { set("amount", Int64Converter.self, toValue: newValue) }
    }
    
    public var currency: Currency? {
        get { return get("currency", StringConverter.self).flatMap(Currency.init(code:)) }
        set { set("currency", StringConverter.self, toValue: newValue?.code) }
    }
    
    public var title: String? {
        get { return get("title", StringConverter.self) }
        set { set("title", StringConverter.self, toValue: newValue) }
    }
    
    public var linkDescription: String? {
        get { return get("description", StringConverter.self) }
        set { set("description", StringConverter.self, toValue: newValue) }
    }
    
    public var isMultiple: Bool? {
        get { return get("multiple", BoolConverter.self) }
        set { set("multiple", BoolConverter.self, toValue: newValue) }
    }
    
}

extension Link: Listable {}

extension Link: Retrievable {}

extension Link: Creatable {
    public typealias CreateParams = LinkParams
}


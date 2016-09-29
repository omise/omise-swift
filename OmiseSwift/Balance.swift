import Foundation

open class Balance: ResourceObject {
    open override class var info: ResourceInfo { return ResourceInfo(path: "/balance") }

    public var available: Int64? {
        get { return get("available", Int64Converter.self) }
        set { set("available", Int64Converter.self, toValue: newValue) }
    }
    
    public var total: Int64? {
        get { return get("total", Int64Converter.self) }
        set { set("total", Int64Converter.self, toValue: newValue) }
    }
    
    public var currency: Currency? {
        get { return get("currency", StringConverter.self).flatMap(Currency.init(code:)) }
        set { set("currency", StringConverter.self, toValue: newValue?.code) }
    }
}

extension Balance: SingletonRetrievable { }

func exampleBalance() {
    _ = Balance.retrieve { (result) in
        switch result {
        case let .success(balance):
            print("balance: \(balance.available)")
        case let .fail(err):
            print("error: \(err)")
        }
    }
}

import Foundation

open class Account: ResourceObject {
    open override class var info: ResourceInfo { return ResourceInfo(path: "/account") }
    
    open var email: String? {
        get { return get("email", StringConverter.self) }
        set { set("email", StringConverter.self, toValue: newValue) }
    }
}

extension Account: SingletonRetrievable { }

func exampleAccount() {
    _ = Account.retrieve { (result) in
        switch result {
        case let .success(result):
            print("account: \(result.email)")
        case let .fail(err):
            print("error: \(err)")
        }
    }
}

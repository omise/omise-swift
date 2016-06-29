import Foundation

public class Account: ResourceObject {
    public override class var info: ResourceInfo { return ResourceInfo(path: "/account") }
    
    public var email: String? {
        get { return get("email", StringConverter.self) }
        set { set("email", StringConverter.self, toValue: newValue) }
    }
}

extension Account: SingletonRetrievable { }

func exampleAccount() {
    Account.retrieve { (result) in
        switch result {
        case let .Success(result):
            print("account: \(result.email)")
        case let .Fail(err):
            print("error: \(err)")
        }
    }
}

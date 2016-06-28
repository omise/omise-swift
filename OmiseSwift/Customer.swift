import Foundation

public class Customer: ResourceObject {
    public var defaultCard: String? {
        get { return get("default_card", StringConverter.self) }
        set { set("default_card", StringConverter.self, toValue: newValue) }
    }
    
    public var email: String? {
        get { return get("email", StringConverter.self) }
        set { set("email", StringConverter.self, toValue: newValue) }
    }
    
    public var customerDescription: String? {
        get { return get("description", StringConverter.self) }
        set { set("description", StringConverter.self, toValue: newValue) }
    }
    
    public var cards: OmiseList<Card>? {
        get { return getChild("cards", OmiseList<Card>.self) }
        set { setChild("cards", OmiseList<Card>.self, toValue: newValue) }
    }
}

public class CustomerParams: Params {
    public var email: String? {
        get { return get("email", StringConverter.self) }
        set { set("email", StringConverter.self, toValue: newValue) }
    }
    
    public var description: String? {
        get { return get("description", StringConverter.self) }
        set { set("description", StringConverter.self, toValue: newValue) }
    }
    
    public var card: String? {
        get { return get("card", StringConverter.self) }
        set { set("card", StringConverter.self, toValue: newValue) }
    }
}

extension Customer: Listable { }
extension Customer: InstanceRetrievable { }

extension Customer: Creatable {
    public typealias CreateParams = CustomerParams
}

extension Customer: Updatable {
    public typealias UpdateParams = CustomerParams
}

extension Customer: Destroyable { }

func exampleCustomer() {
    let today = NSDate()
    let yesterday = today.dateByAddingTimeInterval(-86400)
    
    let listParams = ListParams()
    listParams.from = yesterday
    listParams.to = today
    
    Customer.list(params: listParams) { (result) in
        switch result {
        case let .Success(list):
            print("customers: \(list.data.count)")
        case let .Fail(err):
            print("error: \(err)")
        }
    }
    
    Customer.retrieve(id: "cust_123") { (result) in
        switch result {
        case let .Success(customer):
            print("customer: \(customer.email)")
        case let .Fail(err):
            print("error: \(err)")
        }
    }
    
    let custParams = CustomerParams()
    custParams.email = "test@example.com"
}

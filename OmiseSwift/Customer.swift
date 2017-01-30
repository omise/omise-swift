import Foundation

public class Customer: ResourceObject {
    public override class var info: ResourceInfo { return ResourceInfo(path: "/customers") }
    
    public var defaultCard: String? {
        get { return get("default_card", StringConverter.self) ?? getChild("default_card", Card.self)?.id }
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

public class CustomerFilterParams: OmiseFilterParams {
    public var created: DateComponents? {
        get { return get("created", DateComponentsConverter.self) }
        set { set("created", DateComponentsConverter.self, toValue: newValue) }
    }
}

extension Customer: Listable { }
extension Customer: Retrievable { }

extension Customer: Creatable {
    public typealias CreateParams = CustomerParams
}

extension Customer: Updatable {
    public typealias UpdateParams = CustomerParams
}

extension Customer: Searchable {
    public typealias FilterParams = CustomerFilterParams
}

extension Customer: Destroyable { }

func exampleCustomer() {
    let today = Date()
    let yesterday = today.addingTimeInterval(-86400)
    
    let listParams = ListParams()
    listParams.from = yesterday
    listParams.to = today
    
    _ = Customer.list(params: listParams) { (result) in
        switch result {
        case let .success(list):
            print("customers: \(list.data.count)")
        case let .fail(err):
            print("error: \(err)")
        }
    }
    
    _ = Customer.retrieve(id: "cust_123") { (result) in
        switch result {
        case let .success(customer):
            print("customer: \(customer.email)")
        case let .fail(err):
            print("error: \(err)")
        }
    }
    
    let custParams = CustomerParams()
    custParams.email = "test@example.com"
}

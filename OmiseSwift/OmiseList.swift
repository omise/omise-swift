import Foundation

public class OmiseList<TItem: ResourceObject>: OmiseObject {
    public var from: NSDate? {
        get { return get("from", DateConverter.self) }
        set { set("from", DateConverter.self, toValue: newValue) }
    }
    
    public var to: NSDate? {
        get { return get("to", DateConverter.self) }
        set { set("to", DateConverter.self, toValue: newValue) }
    }
    
    public var limit: Int? {
        get { return get("limit", IntConverter.self) }
        set { set("limit", IntConverter.self, toValue: newValue) }
    }
    
    public var total: Int? {
        get { return get("total", IntConverter.self) }
        set { set("total", IntConverter.self, toValue: newValue) }
    }
    
    public var data: [TItem] {
        get { return getList("data", TItem.self) }
        set { setList("data", TItem.self, toValue: newValue) }
    }
}

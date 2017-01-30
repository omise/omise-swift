import Foundation

public protocol Retrievable { }

public class RetrieveParams: Params {
    public var isExpanded: Bool? {
        get { return get("expand", BoolConverter.self) }
        set { set("expand", BoolConverter.self, toValue: newValue) }
    }
}

public extension Retrievable where Self: ResourceObject {
    public typealias RetrieveOperation = Operation<Self>
    
    public static func retrieveOperation(_ parent: ResourceObject?, id: String) -> RetrieveOperation {
        let retrieveParams = RetrieveParams()
        retrieveParams.isExpanded = true
        return RetrieveOperation(
            endpoint: info.endpoint,
            method: "GET",
            paths: makeResourcePathsWith(context: self, parent: parent, id: id),
            params: retrieveParams
        )
    }
    
    public static func retrieve(using given: Client? = nil, parent: ResourceObject? = nil, id: String, callback: @escaping RetrieveOperation.Callback) -> Request<RetrieveOperation.Result>? {
        guard checkParent(withContext: self, parent: parent) else {
            return nil
        }
        
        let operation = self.retrieveOperation(parent, id: id)
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}

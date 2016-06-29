import Foundation

func omiseWarn(message: String) {
    print("[omise-swift] WARN: \(message)")
}

func resolveClient(given client: Client?, inside context: ResourceObject? = nil) -> Client {
    return client ?? context?.attachedClient ?? Default.client
}

func checkParent(context: ResourceObject.Type, parent: ResourceObject? = nil) -> Bool {
    if let parentType = context.info.parentType {
        guard parentType == parent?.dynamicType else {
            omiseWarn("\(context) requires \(parent.dynamicType) parent!")
            return false
        }
    }
    
    return true
}

func buildResourcePaths(context: ResourceObject.Type, parent: ResourceObject? = nil, id: String? = nil) -> [String] {
    var paths: [String] = []
    if let p = parent {
        paths = [p.dynamicType.info.path, p.id ?? ""] + paths
    }
    
    paths += [context.info.path]
    if let id = id {
        paths += [id]
    }
    
    return paths
}

public class Default {
    private static var _config: Config = Config(publicKey: nil, secretKey: nil, apiVersion: nil, queue: nil)
    private static var _client: Client? = nil
    
    public static var config: Config {
        get {
            return _config
        }
        set {
            _config = newValue
            _client = nil
        }
    }
    
    public static var client: Client {
        get {
            guard let client = _client else {
                _client = Client(config: _config)
                return self.client
            }
            
            return client
        }
        set {
            _client = newValue
        }
    }
}

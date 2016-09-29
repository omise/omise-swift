import Foundation

func omiseWarn(_ message: String) {
    print("[omise-swift] WARN: \(message)")
}

func resolveClient(given client: Client?, inside context: ResourceObject? = nil) -> Client {
    return client ?? context?.attachedClient ?? Default.client
}

func checkParent(withContext context: ResourceObject.Type, parent: ResourceObject? = nil) -> Bool {
    if let parentType = context.info.parentType {
        guard let parentObject = parent, parentType == type(of: parentObject) else {
            omiseWarn("\(context) requires \(type(of: parent)) parent!")
            return false
        }
    }
    
    return true
}

func makeResourcePathsWith(context: ResourceObject.Type, parent: ResourceObject? = nil, id: String? = nil) -> [String] {
    var paths: [String] = []
    if let p = parent {
        paths = [type(of: p).info.path, p.id ?? ""] + paths
    }
    
    paths += [context.info.path]
    if let id = id {
        paths += [id]
    }
    
    return paths
}

open class Default {
    fileprivate static var _config: Config = Config(publicKey: nil, secretKey: nil, apiVersion: nil, queue: nil)
    fileprivate static var _client: Client? = nil
    
    open static var config: Config {
        get {
            return _config
        }
        set {
            _config = newValue
            _client = nil
        }
    }
    
    open static var client: Client {
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

import Foundation

func omiseWarn(message: String) {
    print("[omise-swift] WARN: \(message)")
}

func resolveClient(given client: Client?, inside context: ResourceObject? = nil) -> Client {
    return client ?? context?.attachedClient ?? Default.client
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

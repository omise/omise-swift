import Foundation

public struct AnyAccessKey: AccessKey {
    public let key: String
    
    public init(_ key: String) {
        self.key = key
    }
}



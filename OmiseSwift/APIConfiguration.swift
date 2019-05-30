import Foundation

public protocol AccessKey {
    var key: String { get }
}


public struct APIConfiguration {
    public let apiVersion: String = "2019-05-29"
    public let accessKey: AccessKey
    
    public init(key: AccessKey) {
        self.accessKey = key
    }
}


import Foundation

public protocol AccessKey {
    var key: String { get }
}


public struct APIConfiguration {
    public let apiVersion: String = "2017-11-02"
    public let accessKey: AccessKey
    
    public init(key: AccessKey) {
        self.accessKey = key
    }
}


import Foundation


public struct APIConfiguration {
    public let apiVersion: String = "2015-11-17"
    public let applicationKey: Key<ApplicationKey>
    
    public init(applicationKey: Key<ApplicationKey>) {
        self.applicationKey = applicationKey
    }
}


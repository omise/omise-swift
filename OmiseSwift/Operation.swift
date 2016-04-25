import Foundation

public class Operation {
    public let endpoint: Endpoint
    public let method: String
    public let path: String
    public let values: OmiseObject.Attributes
    
    public var url: NSURL {
        return endpoint.url.URLByAppendingPathComponent(path)
    }
    
    public var payload: NSData? {
        let str = NSMutableString()
        
        for (key, value) in values {
            str.appendString("&")
            
            guard let escapedKey = queryEncode(key) else {
                NSLog("error encoding payload key: \(key)")
                continue
            }
            
            str.appendString(escapedKey)
            str.appendString("=")
            
            switch value {
            case let v as String:
                guard let escapedValue = queryEncode(v) else {
                    NSLog("error encoding payload value: \(value)")
                    continue
                }
                
                str.appendString(escapedValue)
                
            case let n as NSNumber:
                str.appendString(n.stringValue)
                
            case let d as NSDate:
                guard let dateStr = DateConverter.convertToAttribute(d) as? String,
                    let s = queryEncode(dateStr) else {
                    NSLog("error encoding payload date value: \(d)")
                    continue
                }
                
                str.appendString(s)
                
            default: break
                // ignore nils
            }
            
        }
        
        if str.length > 0 { // initial &
            str.deleteCharactersInRange(NSRange(location: 0, length: 1))
        }
        
        return str.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    public init(endpoint: Endpoint, method: String, path: String, values: OmiseObject.Attributes) {
        self.endpoint = endpoint
        self.method = method
        self.path = path
        self.values = values
    }
    
    private func queryEncode(v: String) -> String? {
        return v.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    }
}

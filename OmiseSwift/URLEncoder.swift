import Foundation

public class URLEncoder {
    public class func encode(attributes: OmiseObject.Attributes) -> [NSURLQueryItem] {
        return encodeDict(attributes, parentKey: nil)
            .sort({ (item1, item2) in item1.name < item2.name })
    }
    
    private class func encodeDict(dict: OmiseObject.Attributes, parentKey: String?) -> [NSURLQueryItem] {
        return dict.flatMap(encodePair(parentKey))
    }
    
    private class func encodePair(parentKey: String?) -> (String, NSObject?) -> [NSURLQueryItem] {
        return { (key: String, value: NSObject?) in
            let nestedKey: String
            if let pkey = parentKey {
                nestedKey = "\(pkey)[\(key)]"
            } else {
                nestedKey = key
            }
            
            if let attributes = value as? OmiseObject.Attributes {
                return encodeDict(attributes, parentKey: nestedKey)
            } else {
                return [NSURLQueryItem(name: nestedKey, value: encodeScalar(value))]
            }
        }
    }
    
    private class func encodeScalar(value: NSObject?) -> String? {
        switch value {
        case let s as String:
            return s
            
        case let d as NSDate:
            guard let str = DateConverter.convertToAttribute(d) as? String else {
                return nil
            }
            
            return str
            
        case let n as NSNumber:
            switch CFNumberGetType(n as CFNumber) {
            case .CharType:
                return n.boolValue ? "true" : "false"
            default:
                return n.stringValue
            }
            
            
        default:
            return nil
        }
    }
}
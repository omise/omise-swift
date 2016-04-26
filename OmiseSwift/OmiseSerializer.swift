import Foundation

public class OmiseSerializer {
    public class func serialize(object: OmiseObject) -> NSData? {
        return try? NSJSONSerialization.dataWithJSONObject(
            object.attributes,
            options: NSJSONWritingOptions(rawValue: 0))
    }
    
    public class func deserialize<TObject: OmiseObject>(data: NSData) -> TObject? {
        guard let attributes = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) else {
            return nil
        }
        
        guard let objAttributes = attributes as? OmiseObject.Attributes else {
            return nil
        }
        
        return TObject(attributes: objAttributes)
    }
}

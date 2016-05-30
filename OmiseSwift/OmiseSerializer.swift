import Foundation

public class OmiseSerializer {
    public class func serialize(object: OmiseObject) throws -> NSData {
        return try NSJSONSerialization.dataWithJSONObject(
            object.attributes,
            options: NSJSONWritingOptions(rawValue: 0))
    }
    
    public class func deserialize<TObject: OmiseObject>(data: NSData) throws -> TObject {
        let attributes = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        guard let objAttributes = attributes as? JSONAttributes else {
            throw OmiseError.Unexpected(message: "expected JSON object at top level.")
        }
        
        return TObject(attributes: objAttributes)
    }
}

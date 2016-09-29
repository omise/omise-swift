import Foundation

open class OmiseSerializer {
    open class func serialize(_ object: OmiseObject) throws -> Data {
        return try JSONSerialization.data(
            withJSONObject: object.attributes,
            options: JSONSerialization.WritingOptions(rawValue: 0))
    }
    
    open class func deserialize<TObject: OmiseObject>(_ data: Data) throws -> TObject {
        let attributes = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let objAttributes = attributes as? JSONAttributes else {
            throw OmiseError.unexpected("expected JSON object at top level.")
        }
        
        return TObject(attributes: objAttributes)
    }
}

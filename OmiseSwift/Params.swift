import Foundation

public class Params: AttributesContainer {
    public var attributes: JSONAttributes = [:]
    public var children: [String: AttributesContainer] = [:]
    
    public required init(attributes: JSONAttributes = [:]) {
        self.attributes = attributes
    }
}

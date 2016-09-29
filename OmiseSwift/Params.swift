import Foundation

open class Params: AttributesContainer {
    open var attributes: JSONAttributes = [:]
    open var children: [String: AttributesContainer] = [:]
    
    public required init(attributes: JSONAttributes = [:]) {
        self.attributes = attributes
    }
}

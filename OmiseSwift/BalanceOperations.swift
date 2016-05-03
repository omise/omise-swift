import Foundation

public extension Balance {
    public class Retrieve: DefaultOperation<Balance> {
        public override var path: String { return "/balance" }
        
        public required init(attributes: JSONAttributes = [:]) {
            super.init(attributes: attributes)
        }
    }
}

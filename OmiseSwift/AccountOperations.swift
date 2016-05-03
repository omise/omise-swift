import Foundation

public extension Account {
    public class Retrieve: DefaultOperation<Account> {
        public override var path: String { return "/account" }
        
        public required init(attributes: JSONAttributes = [:]) {
            super.init(attributes: attributes)
        }
    }
}

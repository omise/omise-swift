import Foundation

public class Recipient: ResourceObject {
    public var verified: Bool?
    public var active: Bool?
    public var name: String?
    public var email: String?
    public var recipientDescription: String?
    public var type: RecipientType?
    public var taxID: String?
    // TODO: BankAccount (nested object)
    public var failureCode: String?
}

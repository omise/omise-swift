import Foundation

final class Lookup {
    static var resourceTypeFromName: [String: ResourceObject.Type] = [
        "account": Account.self,
        "balance": Balance.self,
        "bank_account": BankAccount.self,
        "card": Card.self,
        "charge": Charge.self,
        "dispute": Dispute.self,
        "event": Event.self,
        "recipient": Recipient.self,
        "refund": Refund.self,
        "token": Token.self,
        "transfer": Transfer.self,
        "transaction": Transaction.self,
    ]
}

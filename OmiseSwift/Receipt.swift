import Foundation


public struct Receipt: OmiseLocatableObject, OmiseIdentifiableObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/receipts")
    
    public let location: String
    public let object: String
    
    public let id: String
    public let date: Date
    
    public let number: String
    public let isCreditNote: Bool
    
    public let customerName: String
    public let customerAddress: String
    public let customerTaxID: String
    public let customerEmail: String
    public let customerStatementName: String
    
    public let companyName: String
    public let companyAddress: String
    public let companyTaxID: String
    
    public let currency: Currency
    public let chargeFee: Int64
    public let voidedFee: Int64
    public let transferFee: Int64
    public let feeSubtotal: Int64
    public let vat: Int64
    public let wht: Int64
    public let total: Int64
}

extension Receipt {
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case date
        
        case number
        case isCreditNote = "credit_note"
        
        case customerName = "customer_name"
        case customerAddress = "customer_address"
        case customerTaxID = "customer_tax_id"
        case customerEmail = "customer_email"
        case customerStatementName = "customer_statement_name"
        
        case companyName = "company_name"
        case companyAddress = "company_address"
        case companyTaxID = "company_tax_id"
        
        case currency
        case chargeFee = "charge_fee"
        case voidedFee = "voided_fee"
        case transferFee = "transfer_fee"
        case feeSubtotal = "subtotal"
        case vat
        case wht
        case total
    }

}


extension Receipt: Listable {}
extension Receipt: Retrievable {}



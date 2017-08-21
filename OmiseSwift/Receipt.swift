import Foundation


public struct Receipt: OmiseLocatableObject, OmiseIdentifiableObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/receipts")
    
    public let location: String
    public let object: String
    
    public let id: String
    public let date: Date
    
    public let number: String
    
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
    
    public let isCreditNote: Bool
}


extension Receipt {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Receipt.parseOmiseProperties(JSON: json) else {
                return nil
        }
        
        guard let number = json["number"] as? String,
            let isCreditNote = json["credit_note"] as? Bool,
            let date = json["date"].flatMap(DateConverter.convert(fromAttribute:)) else {
                return nil
        }
        
        guard let customerName = json["customer_name"] as? String,
            let customerAddress = json["customer_address"] as? String,
            let customerTaxID = json["customer_tax_id"] as? String,
            let customerEmail = json["customer_email"] as? String,
            let customerStatementName = json["customer_statement_name"] as? String else {
                return nil
        }
        
        guard let companyName = json["company_name"] as? String,
            let companyAddress = json["company_address"] as? String,
            let companyTaxID = json["company_tax_id"] as? String else {
                return nil
        }
        
        guard let currency = (json["currency"] as? String).flatMap(Currency.init(code:)),
            let chargeFee = json["charge_fee"] as? Int64,
            let voidedFee = json["voided_fee"] as? Int64,
            let transferFee = json["transfer_fee"] as? Int64,
            let feeSubtotal = json["subtotal"] as? Int64,
            let vat = json["vat"] as? Int64,
            let wht = json["wht"] as? Int64,
            let total = json["total"] as? Int64 else {
                return nil
        }
        
        assert(feeSubtotal == chargeFee - voidedFee + transferFee, "Fee subtotal doesn't match the fee equation")
        
        (self.object, self.location, self.id) = omiseObjectProperties

        self.number = number
        self.date = date
        
        self.customerName = customerName
        self.customerAddress = customerAddress
        self.customerTaxID = customerTaxID
        self.customerEmail = customerEmail
        self.customerStatementName = customerStatementName
        
        self.companyName = companyName
        self.companyTaxID = companyTaxID
        self.companyAddress = companyAddress
        
        self.currency = currency
        self.chargeFee = chargeFee
        self.voidedFee = voidedFee
        self.transferFee = transferFee
        self.feeSubtotal = feeSubtotal
        self.vat = vat
        self.wht = wht
        self.total = total
        
        
        self.isCreditNote = isCreditNote
    }
}


extension Receipt: Listable {}
extension Receipt: Retrievable {}



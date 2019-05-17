import Foundation


public struct Receipt: OmiseLocatableObject, OmiseIdentifiableObject, Equatable {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/receipts")
    
    public let location: String
    public let object: String
    
    public let isLiveMode: Bool
    public let createdDate: Date
    public let id: String
    public let issuedDateComponents: DateComponents
    
    public let number: String
    public let isCreditNote: Bool
    
    public let customerName: String?
    public let customerAddress: String?
    public let customerTaxID: String?
    public let customerEmail: String?
    public let customerStatementName: String?
    
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
    
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case isLiveMode = "livemode"
        case createdDate = "created_at"
        case issuedDateComponents = "issued_on"
        
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decode(String.self, forKey: .object)
        location = try container.decode(String.self, forKey: .location)
        id = try container.decode(String.self, forKey: .id)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        isLiveMode = try container.decode(Bool.self, forKey: .isLiveMode)
        issuedDateComponents = try container.decodeOmiseDateComponents(forKey: .issuedDateComponents)
        number = try container.decode(String.self, forKey: .number)
        isCreditNote = try container.decode(Bool.self, forKey: .isCreditNote)
        customerName = try container.decodeIfPresent(String.self, forKey: .customerName)
        customerAddress = try container.decodeIfPresent(String.self, forKey: .customerAddress)
        customerTaxID = try container.decodeIfPresent(String.self, forKey: .customerTaxID)
        customerEmail = try container.decodeIfPresent(String.self, forKey: .customerEmail)
        customerStatementName = try container.decodeIfPresent(String.self, forKey: .customerStatementName)
        companyName = try container.decode(String.self, forKey: .companyName)
        companyAddress = try container.decode(String.self, forKey: .companyAddress)
        companyTaxID = try container.decode(String.self, forKey: .companyTaxID)
        currency = try container.decode(Currency.self, forKey: .currency)
        chargeFee = try container.decode(Int64.self, forKey: .chargeFee)
        voidedFee = try container.decode(Int64.self, forKey: .voidedFee)
        transferFee = try container.decode(Int64.self, forKey: .transferFee)
        feeSubtotal = try container.decode(Int64.self, forKey: .feeSubtotal)
        vat = try container.decode(Int64.self, forKey: .vat)
        wht = try container.decode(Int64.self, forKey: .wht)
        total = try container.decode(Int64.self, forKey: .total)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(object, forKey: .object)
        try container.encode(location, forKey: .location)
        try container.encode(id, forKey: .id)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(isLiveMode, forKey: .isLiveMode)
        try container.encodeOmiseDateComponents(issuedDateComponents, forKey: .issuedDateComponents)
        try container.encode(number, forKey: .number)
        try container.encode(isCreditNote, forKey: .isCreditNote)
        try container.encodeIfPresent(customerName, forKey: .customerName)
        try container.encodeIfPresent(customerAddress, forKey: .customerAddress)
        try container.encodeIfPresent(customerTaxID, forKey: .customerTaxID)
        try container.encodeIfPresent(customerEmail, forKey: .customerEmail)
        try container.encodeIfPresent(customerStatementName, forKey: .customerStatementName)
        try container.encode(companyName, forKey: .companyName)
        try container.encode(companyAddress, forKey: .companyAddress)
        try container.encode(companyTaxID, forKey: .companyTaxID)
        try container.encode(currency, forKey: .currency)
        try container.encode(chargeFee, forKey: .chargeFee)
        try container.encode(voidedFee, forKey: .voidedFee)
        try container.encode(transferFee, forKey: .transferFee)
        try container.encode(feeSubtotal, forKey: .feeSubtotal)
        try container.encode(vat, forKey: .vat)
        try container.encode(wht, forKey: .wht)
        try container.encode(total, forKey: .total)
    }
}


extension Receipt: Listable {}
extension Receipt: Retrievable {}



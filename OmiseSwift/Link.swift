import Foundation


public struct Link: OmiseResourceObject, Equatable {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/links")
    
    public let object: String
    
    public let location: String
    public let id: String
    public let isLive: Bool
    public let createdDate: Date
    
    public var value: Value {
        return Value(amount: amount, currency: currency)
    }
    public let amount: Int64
    public let currency: Currency
    
    public let isDeleted: Bool
    
    public let isUsed: Bool
    public let isMultiple: Bool
    public let title: String
    public let linkDescription: String
    public let charges: ListProperty<Charge>
    public let paymentURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case isLive = "livemode"
        case createdDate = "created"
        
        case amount
        case currency
        
        case isDeleted = "deleted"
        
        case isUsed = "used"
        case isMultiple = "multiple"
        case title
        case linkDescription = "description"
        case charges
        case paymentURL = "payment_uri"
    }

}


public struct LinkParams: APIJSONQuery {
    public var value: Value
    public var title: String
    public var linkDescription: String
    public var isMultiple: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case amount
        case currency
        case title
        case linkDescription = "description"
        case isMultiple = "multiple"
    }
    
    public func encode(to encoder: Encoder) throws {
        var keyedContainer = encoder.container(keyedBy: CodingKeys.self)
        try keyedContainer.encode(value.amount, forKey: .amount)
        try keyedContainer.encode(value.currency, forKey: .currency)
        try keyedContainer.encode(title, forKey: .title)
        try keyedContainer.encodeIfPresent(linkDescription, forKey: .linkDescription)
        try keyedContainer.encodeIfPresent(isMultiple, forKey: .isMultiple)
    }
    
    public init(value: Value, title: String, linkDescription: String, isMultiple: Bool? = nil) {
        self.value = value
        self.title = title
        self.linkDescription = linkDescription
        self.isMultiple = isMultiple
    }
}

public struct LinkFilterParams: OmiseFilterParams {
    
    public var created: DateComponents?
    public var amount: Double?
    
    public var isMultiple: Bool?
    public var isUsed: Bool?
    
    public var usedDate: DateComponents?
    
    private enum CodingKeys: String, CodingKey {
        case created
        case amount
        case isMultiple = "multiple"
        case isUsed = "used"
        case usedDate = "used_at"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        created = try container.decodeOmiseDateComponentsIfPresent(forKey: .created)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        isMultiple = try container.decodeIfPresent(Bool.self, forKey: .isMultiple)
        isUsed = try container.decodeIfPresent(Bool.self, forKey: .isUsed)
        usedDate = try container.decodeOmiseDateComponentsIfPresent(forKey: .usedDate)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeOmiseDateComponentsIfPresent(created, forKey: .created)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(isMultiple, forKey: .isMultiple)
        try container.encodeIfPresent(isUsed, forKey: .isUsed)
        try container.encodeOmiseDateComponentsIfPresent(usedDate, forKey: .usedDate)
    }
    
    public init(created: DateComponents? = nil, amount: Double? = nil,
                isMultiple: Bool? = nil, isUsed: Bool? = nil,
                usedDate: DateComponents? = nil) {
        self.created = created
        self.amount = amount
        self.isMultiple = isMultiple
        self.isUsed = isUsed
        self.usedDate = usedDate
    }
}

extension Link: Listable {}

extension Link: Retrievable {}

extension Link: Creatable {
    public typealias CreateParams = LinkParams
}

extension Link: Searchable {
    public typealias FilterParams = LinkFilterParams
}


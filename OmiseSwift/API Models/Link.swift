import Foundation


public struct Link: OmiseResourceObject, Equatable {
    public static let resourcePath = "/links"
    public static let idPrefix: String = "link"
    
    public let object: String
    
    public let location: String
    public let id: DataID<Link>
    public let isLiveMode: Bool
    public let createdDate: Date
    public let isDeleted: Bool
    
    public var value: Value {
        return Value(amount: amount, currency: currency)
    }
    public let amount: Int64
    public let currency: Currency
    
    public let isUsed: Bool
    public let isMultiple: Bool
    public let title: String
    public let linkDescription: String
    public let charges: ListProperty<Charge>
    public let paymentURL: URL
}


extension Link {
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case isLiveMode = "livemode"
        case createdDate = "created_at"
        case isDeleted = "deleted"
        
        case amount
        case currency
        
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
    
    public var amount: Double?
    public var created: DateComponents?
    
    public var isMultiple: Bool?
    public var isUsed: Bool?
    
    public var usedDate: DateComponents?
    
    private enum CodingKeys: String, CodingKey {
        case amount
        case created
        case isMultiple = "multiple"
        case isUsed = "used"
        case usedDate = "used_at"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decodeOmiseAPIValueIfPresent(Double.self, forKey: .amount)
        created = try container.decodeIfPresent(DateComponents.self, forKey: .created)
        isMultiple = try container.decodeOmiseAPIValueIfPresent(Bool.self, forKey: .isMultiple)
        isUsed = try container.decodeOmiseAPIValueIfPresent(Bool.self, forKey: .isUsed)
        usedDate = try container.decodeIfPresent(DateComponents.self, forKey: .usedDate)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(isMultiple, forKey: .isMultiple)
        try container.encodeIfPresent(isUsed, forKey: .isUsed)
        try container.encodeIfPresent(usedDate, forKey: .usedDate)
    }
    
    public init(
        amount: Double? = nil,
        created: DateComponents? = nil,
        isMultiple: Bool? = nil,
        isUsed: Bool? = nil,
        usedDate: DateComponents? = nil
    ) {
        self.amount = amount
        self.created = created
        self.isMultiple = isMultiple
        self.isUsed = isUsed
        self.usedDate = usedDate
    }
}


extension Link: OmiseAPIPrimaryObject {}
extension Link: Listable {}
extension Link: Retrievable {}
extension Link: Destroyable {}

extension Link: Creatable {
    public typealias CreateParams = LinkParams
}

extension Link: Searchable {
    public typealias FilterParams = LinkFilterParams
}

extension Link {
    public func listCharges(
        using client: APIClient, params: ListParams? = nil, callback: @escaping Charge.ListRequest.Callback
        ) -> Charge.ListRequest? {
        return self.list(keyPath: \.charges, using: client, params: params, callback: callback)
    }
}

import Foundation


public struct Link: OmiseResourceObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/links")
    
    public let object: String
    
    public let location: String
    public let id: String
    public let isLive: Bool
    public let createdDate: Date
    
    public let value: Value
    public let isUsed: Bool
    public let isMultiple: Bool
    public let title: String
    public let linkDescription: String
    public let charges: ListProperty<Charge>
    public let paymentURL: URL
}


extension Link {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Link.parseOmiseResource(JSON: json) else {
                return nil
        }
        
        guard let value = Value(JSON: json),
            let isUsed = json["used"] as? Bool, let isMultiple = json["multiple"] as? Bool,
            let title = json["title"] as? String, let linkDescription = json["description"] as? String,
            let charges = json["charges"].flatMap(ListProperty<Charge>.init(JSON:)),
            let paymentURL = (json["payment_uri"] as? String).flatMap(URL.init(string:)) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate) = omiseObjectProperties
        self.value = value
        self.isUsed = isUsed
        self.isMultiple = isMultiple
        self.title = title
        self.linkDescription = linkDescription
        self.charges = charges
        self.paymentURL = paymentURL
    }
}

public struct LinkParams: APIParams {
    public var value: Value
    public var title: String
    public var linkDescription: String
    public var isMultiple: Bool?
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "amount": value.amount,
            "currency": value.currency.code,
            "title": title,
            "description": linkDescription,
            "multiple": isMultiple,
            ])
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
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "created": DateComponentsConverter.convert(fromValue: created),
            "amount": amount,
            "multiple": isMultiple,
            "used": isUsed,
            "used_at": DateComponentsConverter.convert(fromValue: usedDate),
            ])
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
    
    public init(JSON: [String: Any]) {
        self.init(
            created: JSON["created"].flatMap(DateComponentsConverter.convert(fromAttribute:)),
            amount: (JSON["amount"] as? Double),
            isMultiple: JSON["multiple"] as? Bool,
            isUsed: JSON["used"] as? Bool,
            usedDate: JSON["used_at"].flatMap(DateComponentsConverter.convert(fromAttribute:))
        )
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


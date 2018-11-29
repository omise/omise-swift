import Foundation


public struct Capability: OmiseLocatableObject, SingletonRetrievable {
    public static var resourceInfo: ResourceInfo = ResourceInfo(path: "capability")
    
    public let location: String
    public let object: String
    
    public let supportedBanks: Set<String>
    public let chargeLimit: Limit
    public let transferLimit: Limit
    
    public let supportedBackends: [Backend]
}


extension Capability: Codable {
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case supportedBanks = "banks"
        case limits
        case paymentBackends = "payment_backends"
    }
    
    private enum LimitCodingKeys: String, CodingKey {
        case charge = "charge_amount"
        case transfer = "transfer_amount"
    }
}


extension Capability {
    public struct Limit : Codable, Equatable, Hashable {
        public let max: Int64
        public let min: Int64
        
        public var range: ClosedRange<Int64> {
            return min...max
        }
    }
    
    public struct Backend: Codable, Equatable {
        public let payment: Payment
        public let supportedCurrencies: Set<Currency>
        public let limit: Limit?
        
        public enum Payment : Equatable {
            case card(Set<CardBrand>)
            case installment(SourceType.InstallmentBrand, availableNumberOfTerms: IndexSet)
            case internetBanking(InternetBanking)
            case alipay
            case unknownSource(String, configurations: JSONDictionary)
        }
    }
}


extension Capability.Backend {
    private enum CodingKeys: String, CodingKey {
        case type
        case supportedCurrencies = "currencies"
        case limit = "amount"
    }
    
    private enum ConfigurationCodingKeys: String, CodingKey {
        case allowedInstallmentTerms = "allowed_installment_terms"
        case brands
    }
}

extension Capability.Backend.Payment {
    public static func == (lhs: Capability.Backend.Payment, rhs: Capability.Backend.Payment) -> Bool {
        switch (lhs, rhs) {
        case (.card, .card), (.alipay, .alipay):
            return true
        case (.installment(let lhsValue), .installment(let rhsValue)):
            return lhsValue == rhsValue
        case (.internetBanking(let lhsValue), .internetBanking(let rhsValue)):
            return lhsValue == rhsValue
        default:
            return false
        }
    }
    
}

extension Capability {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        location = try container.decode(String.self, forKey: .location)
        object = try container.decode(String.self, forKey: .object)
        
        supportedBanks = try container.decode(Set<String>.self, forKey: .supportedBanks)
        
        let limitsContainer = try container.nestedContainer(keyedBy: LimitCodingKeys.self, forKey: .limits)
        chargeLimit = try limitsContainer.decode(Limit.self, forKey: .charge)
        transferLimit = try limitsContainer.decode(Limit.self, forKey: .transfer)
        
        var backendsContainer = try container.nestedUnkeyedContainer(forKey: .paymentBackends)
        
        var backends: Array<Capability.Backend> = []
        while !backendsContainer.isAtEnd {
            backends.append(try backendsContainer.decode(Capability.Backend.self))
        }
        self.supportedBackends = backends
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
}

extension Capability.Backend {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Capability.Backend.Key.self)
        
        guard let sourceTypeKey = container.allKeys.first else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid backend type")
            )
        }
        
        let backendConfigurations = try container.nestedContainer(keyedBy: Capability.Backend.CodingKeys.self, forKey: sourceTypeKey)
        supportedCurrencies = try backendConfigurations.decode(Set<Currency>.self, forKey: .supportedCurrencies)
        limit = try backendConfigurations.decodeIfPresent(Capability.Limit.self, forKey: .limit)
        
        let type = try backendConfigurations.decode(String.self, forKey: .type)
        guard sourceTypeKey.type == type else {
            throw DecodingError.dataCorruptedError(
                forKey: Capability.Backend.CodingKeys.type, in: backendConfigurations,
                debugDescription: "Invalid payment backend type value"
            )
        }
        
        switch sourceTypeKey {
        case .card:
            let paymentConfigurations = try container.nestedContainer(keyedBy: Capability.Backend.ConfigurationCodingKeys.self, forKey: sourceTypeKey)
            let supportedBrand = try paymentConfigurations.decode(Set<CardBrand>.self, forKey: .brands)
            self.payment = .card(supportedBrand)
        case .source(SourceType.installment(let brand)):
            let paymentConfigurations = try container.nestedContainer(keyedBy: Capability.Backend.ConfigurationCodingKeys.self, forKey: sourceTypeKey)
            let allowedInstallmentTerms = IndexSet(try paymentConfigurations.decode(Array<Int>.self, forKey: .allowedInstallmentTerms))
            self.payment = .installment(brand, availableNumberOfTerms: allowedInstallmentTerms)
        case .source(SourceType.alipay):
            self.payment = .alipay
        case .source(SourceType.internetBanking(let bank)):
            self.payment = .internetBanking(bank)
        case .source(SourceType.unknown(let type)):
            let configurations = try container.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: sourceTypeKey).decodeJSONDictionary().filter({
                $0.key != Capability.Backend.CodingKeys.limit.stringValue
                    && $0.key != Capability.Backend.CodingKeys.supportedCurrencies.stringValue
                    && $0.key != Capability.Backend.CodingKeys.type.stringValue
            })
            self.payment = .unknownSource(type, configurations: configurations)
        case .source(SourceType.billPayment), .source(SourceType.virtualAccount), .source(SourceType.barcode):
            throw DecodingError.dataCorruptedError(
                forKey: Capability.Backend.CodingKeys.type, in: backendConfigurations,
                debugDescription: "Invalid payment backend type value"
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
}


private let creditCardBackendTypeValue = "credit_card"
extension Capability.Backend {
    private enum Key : CodingKey {
        case card
        case source(SourceType)
        
        var stringValue: String {
            switch self {
            case .card:
                return creditCardBackendTypeValue
            case .source(let sourceType):
                return sourceType.value
            }
        }
        
        init?(stringValue: String) {
            switch stringValue {
            case creditCardBackendTypeValue:
                self = .card
            case let value:
                self = .source(SourceType(apiSoureTypeValue: value))
            }
        }
        
        
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
        
        var type: String {
            switch self {
            case .card:
                return "card"
            case .source(let sourceType):
                let sourceTypeValue = sourceType.value
                return sourceTypeValue.firstIndex(of: "_").map(sourceTypeValue.prefix(upTo:)).map(String.init) ?? sourceTypeValue
            }
        }
    }
}


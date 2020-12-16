import Foundation


public struct Capability: OmiseLocatableObject, OmiseAPIPrimaryObject {
    public static var resourcePath: String = "capability"
    
    public let location: String
    public let object: String
    
    public let supportedBanks: Set<String>
    
    public let supportedMethods: [Method]
    
    public let isZeroInterests: Bool
    
    private let methods: [Capability.Method.Key: Method]
    
    public var creditCardMethod: Capability.Method? {
        return methods[.card]
    }
    
    public subscript(sourceType: SourceType) -> Capability.Method? {
        return methods[.source(sourceType)]
    }
}


extension Capability {
    public static func ~=(lhs: Capability, rhs: Charge.CreateParams) -> Bool {
        func method(from capability: Capability, for payment: Charge.CreateParams.Payment) -> Method? {
            switch payment {
            case .card, .customer:
                return capability.creditCardMethod
            case .source(let source):
                return capability[source.sourceType]
            case .sourceType(let parameter):
                return capability[parameter.sourceType]
            }
        }
        
        guard let method = method(from: lhs, for: rhs.payment) else {
            return false
        }
        
        let isValidValue = method.supportedCurrencies.contains(rhs.value.currency)
        
        let isPaymentValid: Bool
        switch method.payment {
        case .installment(_, availableNumberOfTerms: let availableNumberofTerms):
            if case .source(let source) = rhs.payment,
                case .installment(let installment) = source.paymentInformation {
                isPaymentValid = availableNumberofTerms.contains(installment.numberOfTerms)
            } else if case .sourceType(.installment(let installmentParameter)) = rhs.payment {
                isPaymentValid = availableNumberofTerms.contains(installmentParameter.numberOfTerms)
            } else {
                isPaymentValid = false
            }
        default:
            isPaymentValid = true
        }
        
        return isValidValue && isPaymentValid
    }
}


extension Capability {
    public struct Limit : Codable, Equatable, Hashable {
        public let max: Int64
        public let min: Int64
        
        public var range: ClosedRange<Int64> {
            return min...max
        }
        
        public init(min: Int64, max: Int64) {
            self.max = Swift.max(min, max)
            self.min = Swift.min(min, max)
        }
        
        public static func ~=(lhs: Capability.Limit, rhs: Int64) -> Bool {
            return lhs.min <= rhs && rhs <= lhs.max
        }
    }
    
    public struct Method: Codable, Equatable {
        public let payment: Payment
        public let supportedCurrencies: Set<Currency>
        
        public enum Payment : Equatable {
            case card(Set<CardBrand>)
            case installment(SourceType.InstallmentBrand, availableNumberOfTerms: IndexSet)
            case internetBanking(InternetBanking)
            case mobileBanking(MobileBanking)
            case billPayment(SourceType.BillPayment)
            case barcode(SourceType.Barcode)
            case alipay
            case promptPay
            case payNow
            case truemoney
            case payWithPointsCiti
            case unknownSource(String, configurations: JSONDictionary)
        }
    }
}


extension Capability: Codable {
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case supportedBanks = "banks"
        case limits
        case paymentMethods = "payment_methods"
        case isZeroInterests = "zero_interest_installments"
    }
    
    private enum LimitCodingKeys: String, CodingKey {
        case charge = "charge_amount"
        case transfer = "transfer_amount"
    }
}


extension Capability.Method {
    private enum CodingKeys: String, CodingKey {
        case name
        case supportedCurrencies = "currencies"
    }
    
    private enum ConfigurationCodingKeys: String, CodingKey {
        case allowedInstallmentTerms = "installment_terms"
        case brands = "card_brands"
    }
}

extension Capability.Method.Payment {
    public static func == (lhs: Capability.Method.Payment, rhs: Capability.Method.Payment) -> Bool {
        switch (lhs, rhs) {
        case (.card, .card), (.alipay, .alipay):
            return true
        case (.promptPay, .promptPay), (.payNow, .payNow):
            return true
        case (.truemoney, .truemoney):
            return true
        case (.payWithPointsCiti, .payWithPointsCiti):
            return true
        case (.installment(let lhsBrand, let lhsNumberOfTerms), .installment(let rhsBrand, let rhsNumberOfTerms)):
            return lhsBrand == rhsBrand && lhsNumberOfTerms == rhsNumberOfTerms
        case (.internetBanking(let lhsValue), .internetBanking(let rhsValue)):
            return lhsValue == rhsValue
        case (.mobileBanking(let lhsValue), .mobileBanking(let rhsValue)):
            return lhsValue == rhsValue
        case (.billPayment(let lhsValue), .billPayment(let rhsValue)):
            return lhsValue == rhsValue
        case (.barcode(let lhsValue), .barcode(let rhsValue)):
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
        isZeroInterests = try container.decode(Bool.self, forKey: .isZeroInterests)
        
        supportedMethods = try container.decode(Array<Capability.Method>.self, forKey: .paymentMethods)
        methods = Dictionary(
            uniqueKeysWithValues: zip(supportedMethods.map({ Capability.Method.Key(payment: $0.payment) }),
                                      supportedMethods))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(location, forKey: .location)
        try container.encode(object, forKey: .object)
        
        try container.encode(supportedBanks, forKey: .supportedBanks)
        try container.encode(isZeroInterests, forKey: .isZeroInterests)
        
        var methodsContainer = container.nestedUnkeyedContainer(forKey: .paymentMethods)
        try supportedMethods.forEach({ method in
            try methodsContainer.encode(method)
        })
    }
}

extension Capability.Method {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Capability.Method.CodingKeys.self)
        
        let sourceTypeKey = try container.decode(Capability.Method.Key.self, forKey: .name)
        supportedCurrencies = try container.decode(Set<Currency>.self, forKey: .supportedCurrencies)
        
        switch sourceTypeKey {
        case .card:
            let paymentConfigurations = try decoder.container(keyedBy: Capability.Method.ConfigurationCodingKeys.self)
            let supportedBrand = try paymentConfigurations.decode(Set<CardBrand>.self, forKey: .brands)
            self.payment = .card(supportedBrand)
        case .source(SourceType.installment(let brand)):
            let paymentConfigurations = try decoder.container(keyedBy: Capability.Method.ConfigurationCodingKeys.self)
            let allowedInstallmentTerms = IndexSet(
                try paymentConfigurations.decode(Array<Int>.self, forKey: .allowedInstallmentTerms))
            self.payment = .installment(brand, availableNumberOfTerms: allowedInstallmentTerms)
        case .source(SourceType.alipay):
            self.payment = .alipay
        case .source(SourceType.promptPay):
            self.payment = .promptPay
        case .source(SourceType.payNow):
            self.payment = .payNow
        case .source(SourceType.internetBanking(let bank)):
            self.payment = .internetBanking(bank)
        case .source(SourceType.mobileBanking(let bank)):
            self.payment = .mobileBanking(bank)
        case .source(SourceType.truemoney):
            self.payment = .truemoney
        case .source(SourceType.payWithPointsCiti):
            self.payment = .payWithPointsCiti
        case .source(SourceType.billPayment(let billPayment)):
            self.payment = .billPayment(billPayment)
        case .source(SourceType.barcode(let barcode)):
            self.payment = .barcode(barcode)
        case .source(SourceType.unknown(let type)):
            let configurations = try decoder.container(
                keyedBy: SkippingKeyCodingKeys<Capability.Method.CodingKeys>.self).decode()
            self.payment = .unknownSource(type, configurations: configurations)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Capability.Method.CodingKeys.self)
        try container.encode(supportedCurrencies, forKey: .supportedCurrencies)
        
        switch payment {
        case .card(let brands):
            var paymentConfigurations = encoder.container(
                keyedBy: CombineCodingKeys<Capability.Method.CodingKeys, Capability.Method.ConfigurationCodingKeys>.self)
            try paymentConfigurations.encode(brands, forKey: .right(.brands))
            
            try paymentConfigurations.encode(Array(supportedCurrencies), forKey: .left(.supportedCurrencies))
            try paymentConfigurations.encode(Key.card, forKey: .left(.name))
        case .installment(let brand, availableNumberOfTerms: let availableNumberOfTerms):
            var paymentConfigurations = encoder.container(
                keyedBy: CombineCodingKeys<Capability.Method.CodingKeys, Capability.Method.ConfigurationCodingKeys>.self)
            try paymentConfigurations.encode(Array(availableNumberOfTerms), forKey: .right(.allowedInstallmentTerms))
            
            try paymentConfigurations.encode(Array(supportedCurrencies), forKey: .left(.supportedCurrencies))
            try paymentConfigurations.encode(Key.source(SourceType.installment(brand)), forKey: .left(.name))
        case .internetBanking(let bank):
            var methodConfigurations = encoder.container(keyedBy: Capability.Method.CodingKeys.self)
            
            try methodConfigurations.encode(Array(supportedCurrencies), forKey: .supportedCurrencies)
            try methodConfigurations.encode(Key.source(.internetBanking(bank)), forKey: .name)
        case .mobileBanking(let bank):
            var methodConfigurations = encoder.container(keyedBy: Capability.Method.CodingKeys.self)
            
            try methodConfigurations.encode(Array(supportedCurrencies), forKey: .supportedCurrencies)
            try methodConfigurations.encode(Key.source(.mobileBanking(bank)), forKey: .name)
        case .alipay:
            var methodConfigurations = encoder.container(keyedBy: Capability.Method.CodingKeys.self)
            
            try methodConfigurations.encode(Array(supportedCurrencies), forKey: .supportedCurrencies)
            try methodConfigurations.encode(Key.source(.alipay), forKey: .name)
        case .promptPay:
            var methodConfigurations = encoder.container(keyedBy: Capability.Method.CodingKeys.self)
            
            try methodConfigurations.encode(Array(supportedCurrencies), forKey: .supportedCurrencies)
            try methodConfigurations.encode(Key.source(.promptPay), forKey: .name)
        case .payNow:
            var methodConfigurations = encoder.container(keyedBy: Capability.Method.CodingKeys.self)
            
            try methodConfigurations.encode(Array(supportedCurrencies), forKey: .supportedCurrencies)
            try methodConfigurations.encode(Key.source(.payNow), forKey: .name)
        case .truemoney:
            var methodConfigurations = encoder.container(keyedBy: Capability.Method.CodingKeys.self)
            
            try methodConfigurations.encode(Array(supportedCurrencies), forKey: .supportedCurrencies)
            try methodConfigurations.encode(Key.source(.truemoney), forKey: .name)

        case .payWithPointsCiti:
            var methodConfigurations = encoder.container(keyedBy: Capability.Method.CodingKeys.self)
        
            try methodConfigurations.encode(Array(supportedCurrencies), forKey: .supportedCurrencies)
            try methodConfigurations.encode(Key.source(.payWithPointsCiti), forKey: .name)
            
        case .billPayment(let billPayment):
            var methodConfigurations = encoder.container(keyedBy: Capability.Method.CodingKeys.self)
            
            try methodConfigurations.encode(Array(supportedCurrencies), forKey: .supportedCurrencies)
            try methodConfigurations.encode(Key.source(.billPayment(billPayment)), forKey: .name)
            
        case .barcode(let barcode):
            var methodConfigurations = encoder.container(keyedBy: Capability.Method.CodingKeys.self)
            
            try methodConfigurations.encode(Array(supportedCurrencies), forKey: .supportedCurrencies)
            try methodConfigurations.encode(Key.source(.barcode(barcode)), forKey: .name)
            
        case .unknownSource(let source, configurations: let configurations):
            var configurationContainers = encoder.container(
                keyedBy: CombineCodingKeys<Capability.Method.CodingKeys, JSONCodingKeys>.self)
            try configurations.forEach({ (key, value) in
                let key = JSONCodingKeys(key: key)
                switch value {
                case let value as Bool:
                    try configurationContainers.encode(value, forKey: .right(key))
                case let value as Int:
                    try configurationContainers.encode(value, forKey: .right(key))
                case let value as String:
                    try configurationContainers.encode(value, forKey: .right(key))
                case let value as Double:
                    try configurationContainers.encode(value, forKey: .right(key))
                case let value as Dictionary<String, Any>:
                    try configurationContainers.encode(value, forKey: .right(key))
                case let value as Array<Any>:
                    try configurationContainers.encode(value, forKey: .right(key))
                case Optional<Any>.none:
                    try configurationContainers.encodeNil(forKey: .right(key))
                default:
                    throw EncodingError.invalidValue(
                        value,
                        EncodingError.Context(codingPath: configurationContainers.codingPath + [key],
                                              debugDescription: "Invalid JSON value"))
                }
            })
            
            try configurationContainers.encode(Array(supportedCurrencies), forKey: .left(.supportedCurrencies))
            try configurationContainers.encode(Key.source(.unknown(source)), forKey: .left(.name))
        }
    }
}


private let creditCardMethodTypeValue = "card"
extension Capability.Method {
    fileprivate enum Key : RawRepresentable, Hashable, Codable {
        case card
        case source(SourceType)
        
        typealias RawValue = String
        
        var rawValue: String {
            switch self {
            case .card:
                return creditCardMethodTypeValue
            case .source(let sourceType):
                return sourceType.value
            }
        }
        
        init?(rawValue: String) {
            switch rawValue {
            case creditCardMethodTypeValue:
                self = .card
            case let value:
                self = .source(SourceType(apiSoureTypeValue: value))
            }
        }
        
        init(payment: Capability.Method.Payment) {
            switch payment {
            case .card:
                self = .card
            case .alipay:
                self = .source(.alipay)
            case .promptPay:
                self = .source(.promptPay)
            case .payNow:
                self = .source(.payNow)
            case .installment(let brand, availableNumberOfTerms: _):
                self = .source(.installment(brand))
            case .internetBanking(let banking):
                self = .source(.internetBanking(banking))
            case .mobileBanking(let banking):
                self = .source(.mobileBanking(banking))
            case .truemoney:
                self = .source(.truemoney)
            case .payWithPointsCiti:
                self = .source(.payWithPointsCiti)
            case .billPayment(let billPayment):
                self = .source(.billPayment(billPayment))
            case .barcode(let barcode):
                self = .source(.barcode(barcode))
            case .unknownSource(let sourceType, configurations: _):
                self = .source(.unknown(sourceType))
            }
        }
        
        var type: String {
            switch self {
            case .card:
                return "card"
            case .source(let sourceType):
                let sourceTypeValue = sourceType.sourceTypePrefix
                if sourceTypeValue.hasSuffix("_") {
                    return sourceTypeValue.lastIndex(of: "_")
                        .map(sourceTypeValue.prefix(upTo:)).map(String.init) ?? sourceTypeValue
                } else {
                    return sourceTypeValue
                }
            }
        }
    }
}

extension Capability: SingletonRetrievable {}


import Foundation


public struct PaymentSource: SourceData, OmiseResourceObject {
    public static let resourcePath = "sources"
    public static let idPrefix: String = "src"
    
    public typealias PaymentInformation = PaymentSourceInformation
    
    public let id: DataID<PaymentSource>
    public let object: String
    public let isLiveMode: Bool
    public let location: String
    public let createdDate: Date
    
    public let currency: Currency
    public let amount: Int64
    
    public let flow: Flow
    public let paymentInformation: PaymentSourceInformation
    
    public var sourceType: SourceType {
        return paymentInformation.sourceType
    }
    
    public enum PaymentSourceInformation: Codable, Equatable {
        case internetBanking(InternetBanking)
        case alipay
        case billPayment(SourceType.BillPayment)
        case barcode(Barcode)
        case installment(Installment)
        
        case unknown(String)
        
        var sourceType: Omise.SourceType {
            switch self {
            case .internetBanking(let bank):
                return Omise.SourceType.internetBanking(bank)
            case .alipay:
                return Omise.SourceType.alipay
            case .billPayment(let billPayment):
                let bill: Omise.SourceType.BillPayment
                switch billPayment {
                case .tescoLotus:
                    bill = Omise.SourceType.BillPayment.tescoLotus
                case .unknown(let name):
                    bill = Omise.SourceType.BillPayment.unknown(name)
                }
                return Omise.SourceType.billPayment(bill)
            case .barcode(let barcodeInformation):
                let barcode: Omise.SourceType.Barcode
                switch barcodeInformation {
                case .alipay:
                    barcode = .alipay
                case .unknown(let name, _):
                    barcode = .unknown(name)
                }
                return .barcode(barcode)
                
            case .installment(let installment):
                return .installment(installment.brand)
            case .unknown(name: let sourceName):
                return Omise.SourceType.unknown(sourceName)
            }
        }
        
        var value: String {
            return sourceType.value
        }
        
        private enum CodingKeys: String, CodingKey {
            case type
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let typeValue = try container.decode(String.self, forKey: .type)
            
            if typeValue.hasPrefix(internetBankingPrefix),
                let internetBankingOffsite = typeValue
                    .range(of: internetBankingPrefix).map({ String(typeValue[$0.upperBound...]) })
                    .flatMap(InternetBanking.init(rawValue:)).map(PaymentSourceInformation.internetBanking) {
                self = internetBankingOffsite
            } else if typeValue == alipayValue {
                self = .alipay
            } else if typeValue.hasPrefix(billPaymentPrefix),
                let billPaymentOffline = typeValue
                    .range(of: billPaymentPrefix).map({ String(typeValue[$0.upperBound...]) })
                    .flatMap(SourceType.BillPayment.init(rawValue:)).map(PaymentSourceInformation.billPayment) {
                self = billPaymentOffline
            } else if typeValue.hasPrefix(barcodePrefix),
                let barcodeValue = typeValue
                    .range(of: barcodePrefix).map({ String(typeValue[$0.upperBound...]) }) {
                switch barcodeValue {
                case SourceType.Barcode.alipay.rawValue:
                    let alipayBarcode = try Barcode.AlipayBarcode.init(from: decoder)
                    self = .barcode(.alipay(alipayBarcode))
                case let barcodeType:
                    let parameters = try decoder.decode(
                        as: Dictionary<String, Any>.self, skippingKeys: PaymentSource.CodingKeys.self)
                    self = .barcode(.unknown(name: barcodeType, parameters: parameters))
                }
            } else if typeValue.hasPrefix(installmentPrefix) {
                self = .installment(try Installment(from: decoder))
            } else {
                self = .unknown(typeValue)
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(value, forKey: .type)
            
            switch self {
            case .barcode(let barcodeInformation):
                try barcodeInformation.encode(to: encoder)
            case .installment(let parameter):
                try parameter.encode(to: encoder)
            default: break
            }
        }
    }
}

extension PaymentSource {
    fileprivate enum CodingKeys: String, CodingKey {
        case id
        case object
        case isLiveMode = "livemode"
        case location
        case createdDate = "created_at"
        case currency
        case amount
        case flow
        case type
        case references
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(DataID<PaymentSource>.self, forKey: .id)
        object = try container.decode(String.self, forKey: .object)
        isLiveMode = try container.decode(Bool.self, forKey: .isLiveMode)
        location = try container.decode(String.self, forKey: .location)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        currency = try container.decode(Currency.self, forKey: .currency)
        amount = try container.decode(Int64.self, forKey: .amount)
        flow = try container.decode(Flow.self, forKey: .flow)
        paymentInformation = try PaymentSourceInformation(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(object, forKey: .object)
        try container.encode(isLiveMode, forKey: .isLiveMode)
        try container.encode(location, forKey: .location)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(amount, forKey: .amount)
        try container.encode(currency, forKey: .currency)
        try container.encode(flow, forKey: .flow)
        try paymentInformation.encode(to: encoder)
    }
}


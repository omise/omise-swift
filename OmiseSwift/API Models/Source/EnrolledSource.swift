import Foundation


public struct EnrolledSource: SourceData {
    public typealias PaymentInformation = EnrolledSource.EnrolledPaymentInformation
    
    public enum EnrolledPaymentInformation: Codable, Equatable {
        case internetBanking(InternetBanking)
        case mobileBanking(MobileBanking)
        case alipay
        case promptPay(ScannableCode?)
        case payNow(ScannableCode?)
        case billPayment(BillPayment)
        case barcode(Barcode)
        case installment(SourceType.InstallmentBrand)
        case truemoney(Truemoney)
        case payWithPointsCiti
        case fpx(FPXBank)
        
        case unknown(name: String, references: [String: Any]?)
        
        public enum BillPayment: Equatable {
            
            case tescoLotus(BillInformation?)
            case unknown(name: String, references: [String: Any])
            
            public struct BillInformation: Codable, Equatable {
                let omiseTaxID: String
                let referenceNumber1: String
                let referenceNumber2: String
                let barcodeURL: URL
                let expiredDate: Date
                
                private enum CodingKeys: String, CodingKey {
                    case omiseTaxID = "omise_tax_id"
                    case referenceNumber1 = "reference_number_1"
                    case referenceNumber2 = "reference_number_2"
                    case barcodeURL = "barcode"
                    case expiredDate = "expires_at"
                }
            }
            
            public static func ==(lhs: BillPayment, rhs: BillPayment) -> Bool {
                switch (lhs, rhs) {
                case let (.tescoLotus(lhsValue), .tescoLotus(rhsValue)):
                    return lhsValue == rhsValue
                case let (.unknown(name: lhsName, references: _), .unknown(name: rhsName, references: _)):
                    return lhsName == rhsName
                default: return false
                }
            }
        }
        
        public enum Barcode: Equatable {
            case alipay(AlipayBarcode?)
            case weChatPay
            case unknown(name: String, references: [String: Any])
            
            var value: String {
                let value: String
                switch self {
                case .alipay:
                    value = "alipay"
                case .weChatPay:
                    value = "wechat"
                case .unknown(name: let name, references: _):
                    value = name
                }
                return value
            }
            
            public struct AlipayBarcode: Codable {
                public let expiredDate: Date
                fileprivate enum CodingKeys: String, CodingKey {
                    case expiredDate = "expires_at"
                }
            }
            
            public static func ==(
                lhs: EnrolledSource.EnrolledPaymentInformation.Barcode,
                rhs: EnrolledSource.EnrolledPaymentInformation.Barcode
                ) -> Bool {
                switch (lhs, rhs) {
                case (.alipay, .alipay):
                    return true
                case (.weChatPay, .weChatPay):
                    return true
                case let (.unknown(name: lhsName, references: _), .unknown(name: rhsName, references: _)):
                    return lhsName == rhsName
                default: return false
                }
            }
        }
        
        var sourceType: Omise.SourceType {
            switch self {
            case .internetBanking(let bank):
                return Omise.SourceType.internetBanking(bank)
            case .mobileBanking(let bank):
                return Omise.SourceType.mobileBanking(bank)
            case .alipay:
                return Omise.SourceType.alipay
            case .promptPay:
                return Omise.SourceType.promptPay
            case .payNow:
                return Omise.SourceType.payNow
            case .billPayment(let billPayment):
                let bill: Omise.SourceType.BillPayment
                switch billPayment {
                case .tescoLotus:
                    bill = Omise.SourceType.BillPayment.tescoLotus
                case .unknown(let name, _):
                    bill = Omise.SourceType.BillPayment.unknown(name)
                }
                return Omise.SourceType.billPayment(bill)
            case .barcode(let barcodeInformation):
                let barcode: Omise.SourceType.Barcode
                switch barcodeInformation {
                case .alipay:
                    barcode = .alipay
                case .weChatPay:
                    barcode = .weChatPay
                case .unknown(name: let name, references: _):
                    barcode = .unknown(name)
                }
                return .barcode(barcode)
            case .installment(let installmentBrand):
                return Omise.SourceType.installment(installmentBrand)
            case .truemoney:
                return Omise.SourceType.truemoney
            case .payWithPointsCiti:
                return Omise.SourceType.payWithPointsCiti
            case .fpx(let fpxBank):
                return Omise.SourceType.fpx(fpxBank)
            case .unknown(name: let sourceName, references: _):
                return Omise.SourceType.unknown(sourceName)
            }
        }
        
        public static func ==(
            lhs: EnrolledSource.EnrolledPaymentInformation,
            rhs: EnrolledSource.EnrolledPaymentInformation
            ) -> Bool {
            switch (lhs, rhs) {
            case (.internetBanking(let lhsValue), .internetBanking(let rhsValue)):
                return lhsValue == rhsValue
            case (.mobileBanking(let lhsValue), .mobileBanking(let rhsValue)):
                return lhsValue == rhsValue
            case (.alipay, .alipay):
                return true
            case (.promptPay, .promptPay):
                return true
            case (.payNow, .payNow):
                return true
            case (.billPayment(let lhsValue), .billPayment(let rhsValue)):
                return lhsValue == rhsValue
            case (.barcode(let lhsValue), .barcode(let rhsValue)):
                return lhsValue == rhsValue
            case (.installment(let lhsValue), .installment(let rhsValue)):
                return lhsValue == rhsValue
            case (.fpx(let lhsValue), .fpx(let rhsValue)):
                return lhsValue == rhsValue
                
            default: return false
            }
        }
    }
    
    public static let idPrefix: String = "src"
    public let id: DataID<EnrolledSource>
    public let object: String
    
    public let currency: Currency
    public let amount: Int64
    
    public let flow: Flow
    public let paymentInformation: PaymentInformation
    
    public var sourceType: SourceType {
        return paymentInformation.sourceType
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case object
        case currency
        case amount
        case flow
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(DataID<EnrolledSource>.self, forKey: .id)
        object = try container.decode(String.self, forKey: .object)
        currency = try container.decode(Currency.self, forKey: .currency)
        amount = try container.decode(Int64.self, forKey: .amount)
        flow = try container.decode(Flow.self, forKey: .flow)
        paymentInformation = try PaymentInformation.init(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(object, forKey: .object)
        try container.encode(id, forKey: .id)
        try container.encode(currency, forKey: .currency)
        try container.encode(amount, forKey: .amount)
        try container.encode(flow, forKey: .flow)
        try paymentInformation.encode(to: encoder)
    }
}


extension EnrolledSource.EnrolledPaymentInformation {
    private enum CodingKeys: String, CodingKey {
        case type
        case references
        case phoneNumber = "phone_number"
        case scannableCode = "scannable_code"
        case bank
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let typeValue = try container.decode(String.self, forKey: .type)
        
        if typeValue.hasPrefix(internetBankingPrefix),
            let internetBankingOffsite = typeValue
                .range(of: internetBankingPrefix).map({ String(typeValue[$0.upperBound...]) })
                .flatMap(InternetBanking.init(rawValue:)).map(EnrolledSource.PaymentInformation.internetBanking) {
            self = internetBankingOffsite
        } else if typeValue.hasPrefix(mobileBankingPrefix),
            let mobileBankingOffsite = typeValue
                .range(of: mobileBankingPrefix).map({ String(typeValue[$0.upperBound...]) })
                .flatMap(MobileBanking.init(rawValue:)).map(EnrolledSource.PaymentInformation.mobileBanking) {
            self = mobileBankingOffsite
        } else if typeValue == alipayValue {
            self = .alipay
        } else if typeValue == promptPayValue {
            let scannableCode = try container.decode(ScannableCode.self, forKey: .scannableCode)
            self = .promptPay(scannableCode)
        } else if typeValue == payNowValue {
            let scannableCode = try container.decode(ScannableCode.self, forKey: .scannableCode)
            self = .payNow(scannableCode)
        } else if typeValue.hasPrefix(billPaymentPrefix),
            let billPaymentValue = typeValue
                .range(of: billPaymentPrefix).map({ String(typeValue[$0.upperBound...]) }) {
            switch billPaymentValue {
            case SourceType.BillPayment.tescoLotus.rawValue:
                let billInformation = try container.decode(BillPayment.BillInformation.self, forKey: .references)
                self = .billPayment(.tescoLotus(billInformation))
            case let billPaymentType:
                let references = try container.decodeIfPresent(Dictionary<String, Any>.self, forKey: .references)
                self = .billPayment(.unknown(name: billPaymentType, references: references ?? [:]))
            }
        } else if typeValue.hasPrefix(barcodePrefix),
            let barcodeValue = typeValue
                .range(of: barcodePrefix).map({ String(typeValue[$0.upperBound...]) }) {
            switch barcodeValue {
            case SourceType.Barcode.alipay.rawValue:
                let alipayBarcode = try container.decode(Barcode.AlipayBarcode.self, forKey: .references)
                self = .barcode(.alipay(alipayBarcode))
            case SourceType.Barcode.weChatPay.rawValue:
                self = .barcode(.weChatPay)
            case let barcodeType:
                let references = try container.decodeIfPresent(Dictionary<String, Any>.self, forKey: .references)
                self = .barcode(.unknown(name: barcodeType, references: references ?? [:]))
            }
        } else if typeValue.hasPrefix(installmentPrefix),
            let installmentValue = typeValue
                .range(of: installmentPrefix)
                .map({ String(typeValue[$0.upperBound...]) })
                .flatMap(SourceType.InstallmentBrand.init(rawValue:)) {
            self = .installment(installmentValue)
        } else if typeValue == truemoneyValue {
            let truemoney = try Truemoney(from: decoder)
            self = .truemoney(truemoney)
        } else if typeValue == payWithPointsCitiValue {
            self = .payWithPointsCiti
        } else if typeValue == fpxValue {
            let fpx = try FPXBank(from: decoder)
            self = .fpx(fpx)
        } else {
            let references = try container.decodeIfPresent(Dictionary<String, Any>.self, forKey: .references)
            self = .unknown(name: typeValue, references: references)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .internetBanking(let bank):
            try container.encode(internetBankingPrefix + bank.rawValue, forKey: .type)
        case .mobileBanking(let bank):
            try container.encode(mobileBankingPrefix + bank.rawValue, forKey: .type)
        case .alipay:
            try container.encode(alipayValue, forKey: .type)
        case .promptPay(let scannableCode):
            try container.encode(promptPayValue, forKey: .type)
            try container.encode(scannableCode, forKey: .scannableCode)
        case .payNow(let scannableCode):
            try container.encode(payNowValue, forKey: .type)
            try container.encode(scannableCode, forKey: .scannableCode)
        case .billPayment(let billPayment):
            switch billPayment {
            case .tescoLotus(let bill):
                try container.encode(billPaymentPrefix + SourceType.BillPayment.tescoLotus.rawValue, forKey: .type)
                try container.encode(bill, forKey: .references)
            case let .unknown(name: name, references: references):
                try container.encode(billPaymentPrefix + name, forKey: .type)
                try container.encode(references, forKey: .references)
            }
        case .barcode(let barcode):
            switch barcode {
            case .alipay(let alipayBarcode):
                try container.encode(barcodePrefix + SourceType.Barcode.alipay.rawValue, forKey: .type)
                try container.encode(alipayBarcode, forKey: .references)
            case .weChatPay:
                try container.encode(barcodePrefix + SourceType.Barcode.weChatPay.rawValue, forKey: .type)
            case let .unknown(name: name, references: references):
                try container.encode(barcodePrefix + name, forKey: .type)
                try container.encode(references, forKey: .references)
            }
        case .installment:
            try container.encode(sourceType, forKey: .type)
        case .truemoney(let truemoney):
            try container.encode(sourceType, forKey: .type)
            try container.encode(truemoney.phoneNumber, forKey: .phoneNumber)
        case .payWithPointsCiti:
            try container.encode(sourceType, forKey: .type)
        case .fpx(let fpxBank):
            try container.encode(fpxValue, forKey: .type)
            try container.encode(fpxBank, forKey: .bank)
        case .unknown(name: let sourceType, references: let references):
            try container.encode(sourceType, forKey: .type)
            try container.encodeIfPresent(references, forKey: .references)
        }
    }
}

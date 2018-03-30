
public enum DetailProperty<T: OmiseIdentifiableObject> {
    case notLoaded(String)
    indirect case loaded(T)
    
    public var dataID: String {
        switch self {
        case .notLoaded(let dataID):
            return dataID
        case .loaded(let data):
            return data.id
        }
    }
}

extension DetailProperty: Equatable where T: Equatable {
    public static func == (lhs: DetailProperty<T>, rhs: DetailProperty<T>) -> Bool {
        return lhs.dataID == rhs.dataID
    }
}

extension DetailProperty: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = .loaded(try container.decode(T.self))
        } catch DecodingError.typeMismatch {
            self = .notLoaded(try container.decode(String.self))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .loaded(let value):
            try container.encode(value)
        case .notLoaded(let dataID):
            try container.encode(dataID)
        }
    }
}


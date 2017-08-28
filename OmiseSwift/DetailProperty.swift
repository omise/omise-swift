
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

extension DetailProperty: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = .loaded(try container.decode(T.self))
        } catch DecodingError.typeMismatch {
            self = .notLoaded(try container.decode(String.self))
        }
    }
}


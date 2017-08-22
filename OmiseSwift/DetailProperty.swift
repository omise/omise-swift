
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


extension DetailProperty {
    public init?(JSON json: Any) {
        if let data = T(JSON: json) {
            self = .loaded(data)
        } else if let dataID = (json as? String) ?? (json as? [String: Any])?["id"] as? String {
            self = .notLoaded(dataID)
        } else {
            return nil
        }
    }
}


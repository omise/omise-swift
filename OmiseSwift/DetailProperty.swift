
public enum DetailProperty<T: OmiseResourceObject> {
    case notLoaded(String)
    indirect case loaded(T)
}


extension DetailProperty {
    init?(JSON json: Any) {
        if let data = T(JSON: json) {
            self = .loaded(data)
        } else if let dataID = (json as? String) ?? (json as? [String: Any])?["id"] as? String {
            self = .notLoaded(dataID)
        } else {
            return nil
        }
    }
}

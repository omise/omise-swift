import Foundation


public protocol APIQuery: Encodable {}

public protocol APIURLQuery: APIQuery {}

public protocol APIJSONQuery: APIQuery {}

public protocol APIMultipartFormQuery: APIQuery {}

public protocol APIFileQuery: APIMultipartFormQuery {
    var filename: String { get }
    var fileContent: Data { get }
}

public enum NoAPIQuery: APIQuery {
    public func encode(to encoder: Encoder) throws {}
}


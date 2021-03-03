import Foundation


public protocol APIQuery: Encodable {
    func makePayload() -> (String, Data)?
}

public protocol APIURLQuery: APIQuery {}

public protocol APIJSONQuery: APIQuery {}

public protocol APIMultipartFormQuery: APIQuery {}

public protocol APIFileQuery: APIMultipartFormQuery {
    var filename: String { get }
    var fileContent: Data { get }
}

public enum NoAPIQuery: APIQuery {
    public func makePayload() -> (String, Data)? {
        return nil
    }
    
    public func encode(to encoder: Encoder) throws {}
}


extension APIURLQuery {
    public func makePayload() -> (String, Data)? {
        var urlComponents = URLComponents()
        let encoder = URLQueryItemEncoder()
        encoder.arrayIndexEncodingStrategy = .emptySquareBrackets
        urlComponents.queryItems = try? encoder.encode(self)
        return urlComponents.percentEncodedQuery?.data(using: .utf8)
            .map({ ("application/x-www-form-urlencoded", $0) })
    }
}

extension APIJSONQuery {
    public func makePayload() -> (String, Data)? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try? encoder.encode(self)
        return data.map({ ("application/json", $0) })
    }
}

extension APIFileQuery {
    public func makePayload() -> (String, Data)? {
        let crlf = "\r\n"
        let boundary = "------\(UUID().uuidString)"
        
        var data = Data()
        data.append("--\(boundary)\(crlf)".data(using: .utf8, allowLossyConversion: false)!)
        data.append(#"Content-Disposition: form-data; name="file\"; filename="\#(self.filename)"\#(crlf + crlf)"#
            .data(using: .utf8, allowLossyConversion: false)!)
        data.append(self.fileContent)
        data.append("\(crlf)--\(boundary)--".data(using: .utf8, allowLossyConversion: false)!)
        
        return ("multipart/form-data; boundary=\(boundary)", data)
    }
}

import Foundation


public struct Document: OmiseResourceObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(parentType: Dispute.self, path: "documents")
    
    public let object: String
    public let location: String
    
    public let id: String
    public let isLive: Bool
    public var createdDate: Date
    
    public let filename: String
}


extension Document {
    
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Document.parseOmiseResource(JSON: json) else {
                return nil
        }
        
        guard let filename = json["filename"] as? String else {
            return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate) = omiseObjectProperties
        self.filename = filename
    }
}


extension Document: Listable {}
extension Document: Retrievable {}
extension Document: Destroyable {}

public struct DocumentParams: APIFileQuery {
    public var filename: String
    public var fileContent: Data

    public init(url: URL) {
        self.fileContent = try! Data(contentsOf: url, options: .mappedIfSafe)
        self.filename = url.lastPathComponent
    }
}

extension Document: Creatable {
    public typealias CreateParams = DocumentParams
    
    public static func createEndpointWith(parent: OmiseResourceObject?, params: CreateParams) -> CreateEndpoint {
        return CreateEndpoint(
            pathComponents: Document.makeResourcePathsWithParent(parent),
            parameter: .post(params)
        )
    }
    
    public static func create(using client: APIClient, parent: OmiseResourceObject? = nil, params: CreateParams, callback: @escaping CreateRequest.Callback) -> CreateRequest? {
        guard Document.verifyParent(parent) else {
            return nil
        }
        
        let endpoint = self.createEndpointWith(parent: parent, params: params)
        return client.requestToEndpoint(endpoint, callback: callback)
    }
}


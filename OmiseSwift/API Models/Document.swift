import Foundation


public struct Document: OmiseLocatableObject, OmiseIdentifiableObject, OmiseLiveModeObject, OmiseCreatedObject, Equatable {
    public static let resourcePath = "documents"
    public static let idPrefix: String = "docu"
    
    public let object: String
    public let location: String
    
    public let id: DataID<Document>
    public let isLiveMode: Bool
    public let createdDate: Date
    public let isDeleted: Bool
    
    public let filename: String
    public let downloadURL: URL?
}

extension Document {
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case isLiveMode = "livemode"
        case createdDate = "created_at"
        case isDeleted = "deleted"
        case filename
        case downloadURL = "download_uri"
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

extension Document: OmiseAPIChildObject {
    public typealias Parent = Dispute
}

extension Document: Creatable {
    public typealias CreateParams = DocumentParams
}


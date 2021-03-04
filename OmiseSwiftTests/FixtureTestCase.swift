import XCTest
@testable import Omise

class FixtureTestCase: OmiseTestCase {
    var testClient: FixtureClient {
        let config = APIConfiguration(key: AnyAccessKey(""))
        return FixtureClient(config: config)
    }
    
    private var apiOmiseFixturesDirectoryURL: URL!
    
    override func setUpWithError() throws {
        let bundle = Bundle(for: FixtureClient.self)
        let url = try XCTUnwrap(bundle.url(forResource: "Fixtures", withExtension: nil))
        apiOmiseFixturesDirectoryURL = url.appendingPathComponent("api.omise.co")
        
        try super.setUpWithError()
    }
    
    func fixturesObjectFor<T: OmiseLocatableObject>(type: T.Type, dataID: DataID<T>, suffix: String? = nil) throws -> T {
        return try fixturesObjectFor(type: type, dataID: dataID.idString, suffix: suffix)
    }
    
    func fixturesObjectFor<T: OmiseLocatableObject>(type: T.Type, dataID: String, suffix: String? = nil) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        var fileURL: URL = apiOmiseFixturesDirectoryURL
        let resourcePathIndex = T.resourcePath.firstIndex { $0 != "/" } ?? T.resourcePath.startIndex
        fileURL.appendPathComponent(String(T.resourcePath.suffix(from: resourcePathIndex)))
        
        var dataIDComponent = dataID
        
        if let suffix = suffix {
            dataIDComponent += "-\(suffix)"
        }
        dataIDComponent += "-get"
        
        fileURL.appendPathComponent(dataIDComponent)
        fileURL.appendPathExtension("json")
        
        guard let data = try? Data(contentsOf: fileURL) else {
            throw NSError(domain: URLError.errorDomain, code: URLError.fileDoesNotExist.rawValue, userInfo: [
                NSURLErrorFailingURLErrorKey: fileURL
            ])
        }
        
        return try decoder.decode(T.self, from: data)
    }
    
    
    func fixturesObjectFor<T: OmiseLocatableObject & SingletonRetrievable>(
        type: T.Type, suffix: String? = nil
        ) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        var fileURL: URL = self.apiOmiseFixturesDirectoryURL
        var dataIDComponent = String(
            T.resourcePath.suffix(from: T.resourcePath.firstIndex { $0 != "/" } ?? T.resourcePath.startIndex))
        
        if let suffix = suffix {
            dataIDComponent += "-\(suffix)"
        }
        dataIDComponent += "-get"
        
        fileURL.appendPathComponent(dataIDComponent)
        fileURL.appendPathExtension("json")
        
        guard let data = try? Data(contentsOf: fileURL) else {
            throw NSError(domain: URLError.errorDomain, code: URLError.fileDoesNotExist.rawValue, userInfo: [
                NSURLErrorFailingURLErrorKey: fileURL
            ])
        }
        
        return try decoder.decode(T.self, from: data)
    }
}

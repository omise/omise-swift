import XCTest
@testable import Omise

class FixtureTestCase: OmiseTestCase {
    var testClient: FixtureClient {
        let config = APIConfiguration(key: AnyAccessKey(""))
        return FixtureClient(config: config)
    }
    
    static let fixturesDirectoryURL = Bundle(for: FixtureClient.self).url(forResource: "Fixtures", withExtension: nil)!
    static let apiOmiseFixturesDirectoryURL = Bundle(for: FixtureClient.self).url(forResource: "Fixtures", withExtension: nil)!.appendingPathComponent("api.omise.co")
    
    func fixturesObjectFor<T: OmiseIdentifiableObject & OmiseLocatableObject>(type: T.Type, dataID: String, suffix: String? = nil) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        var fileURL = FixtureTestCase.apiOmiseFixturesDirectoryURL
        fileURL.appendPathComponent(String(T.resourceInfo.path.suffix(from: T.resourceInfo.path.index(where: { $0 != "/"}) ?? T.resourceInfo.path.startIndex)))
        var dataIDComponent = dataID
        
        if let suffix = suffix {
            dataIDComponent += "-\(suffix)"
        }
        dataIDComponent += "-get"
        
        fileURL.appendPathComponent(dataIDComponent)
        fileURL.appendPathExtension("json")
        
        guard let data = try? Data(contentsOf: fileURL) else {
            throw NSError(domain: URLError.errorDomain, code: URLError.fileDoesNotExist.rawValue, userInfo: [
                NSURLErrorFailingURLErrorKey: fileURL,
            ])
        }
        
        return try decoder.decode(T.self, from: data)
    }
}

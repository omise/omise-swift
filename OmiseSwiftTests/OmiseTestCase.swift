import XCTest

class OmiseTestCase: XCTestCase {
    func fixturesData(for filename: String) -> Data? {
        let bundle = Bundle(for: OmiseTestCase.self)
        guard let path = bundle.path(forResource: filename, ofType: "json") else {
            XCTFail("could not load fixtures.")
            return nil
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            XCTFail("could not load fixtures at path: \(path)")
            return nil
        }
        
        return data
    }
}

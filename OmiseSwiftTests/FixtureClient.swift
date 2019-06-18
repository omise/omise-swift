import Foundation
@testable import Omise


class FixtureClient: APIClient {    
    let fixturesDirectoryURL: URL
    
    public override init(config: APIConfiguration) {
        let bundle = Bundle(for: FixtureClient.self)
        self.fixturesDirectoryURL = bundle.url(forResource: "Fixtures", withExtension: nil)!
        
        super.init(config: config)
    }
    
    @discardableResult
    override func request<QueryType, TResult>(
        to endpoint: APIEndpoint<QueryType, TResult>,
        callback: ((Result<TResult, OmiseError>) -> Void)?)
        -> APIRequest<QueryType, TResult>? where QueryType : APIQuery, TResult : OmiseObject {
            do {
                let req: FixtureRequest<QueryType, TResult> = FixtureRequest(
                    client: self, endpoint: endpoint, callback: callback)
                return try req.start()
            } catch let err as NSError {
                operationQueue.addOperation() { callback?(.failure(.other(err))) }
            } catch let err as OmiseError {
                operationQueue.addOperation() { callback?(.failure(err)) }
            }
            
            return nil
    }
}


class FixtureRequest<QueryType: APIQuery, TResult: OmiseObject>: APIRequest<QueryType, TResult> {
    var fixtureClient: FixtureClient? {
        return client as? FixtureClient
    }
    
    override func start() throws -> Self {
        let fixtureFilePath = endpoint.fixtureFilePath
        let fixtureFileURL = (client as! FixtureClient).fixturesDirectoryURL.appendingPathComponent(fixtureFilePath)
        DispatchQueue.global().async {
            let data: Data?
            let error: Error?
            
            defer {
                self.didComplete(data: data, error: error)
            }
            
            do {
                data = try Data(contentsOf: fixtureFileURL)
                error = nil
            } catch let thrownError {
                data = nil
                error = thrownError
            }
        }
        return self
    }
    
    fileprivate func didComplete(data: Data?, error: Error?) {
        guard callback != nil else { return }
        
        if let err = error {
            return performCallback(.failure(.other(err)))
        }
        
        guard let data = data else {
            return performCallback(.failure(.unexpected("empty response.")))
        }
        
        do {
            let result: TResult = try deserializeData(data)
            return performCallback(.success(result))
        } catch let err as OmiseError {
            return performCallback(.failure(err))
        } catch let err as DecodingError {
            return performCallback(.failure(.other(err)))
        } catch let err as NSError {
            return performCallback(.failure(.other(err)))
        }
    }
    
    fileprivate func performCallback(_ result: APIResult<TResult>) {
        guard let cb = callback else { return }
        client.operationQueue.addOperation { cb(result) }
    }
}


protocol AdditionalFixtureData {
    var fixtureFileSuffix: String? { get }
}

extension Omise.APIEndpoint {
    var fixtureFilePath: String {
        guard let components = URLComponents(url: makeURL(), resolvingAgainstBaseURL: true),
            let hostname = components.host else {
                preconditionFailure("Invalid URL")
        }
        
        let filePath = pathComponents.reduce(hostname) { (path: String, segment: String) -> String in
            return ((path as NSString).appendingPathComponent(segment)) as String
        }
        
        let fixtureFileSuffix: String?
        if let query = query as? (APIQuery & AdditionalFixtureData) {
            fixtureFileSuffix = query.fixtureFileSuffix
        } else {
            fixtureFileSuffix = nil
        }
        
        var filename = filePath
        if let fixtureFileSuffix = fixtureFileSuffix {
            filename += "-\(fixtureFileSuffix)"
        }
        filename += "-" + method.rawValue.lowercased()
        return (filename as NSString).appendingPathExtension("json")! as String
    }
}


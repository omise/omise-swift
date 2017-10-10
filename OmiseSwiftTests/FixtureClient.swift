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
    override func requestToEndpoint<TResult>(_ endpoint: APIEndpoint<TResult>, callback: APIRequest<TResult>.Callback?) -> APIRequest<TResult>? {
        do {
            let req: FixtureRequest<TResult> = FixtureRequest(client: self, endpoint: endpoint, callback: callback)
            return try req.start()
        } catch let err as NSError {
            operationQueue.addOperation() { callback?(.fail(.other(err))) }
        } catch let err as OmiseError {
            operationQueue.addOperation() { callback?(.fail(err)) }
        }
        
        return nil
    }
}


class FixtureRequest<TResult: OmiseObject>: APIRequest<TResult> {
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
            return performCallback(.fail(.other(err)))
        }
        
        guard let data = data else {
            return performCallback(.fail(.unexpected("empty response.")))
        }
        
        do {
            let result: TResult = try deserializeData(data)
            return performCallback(.success(result))
        } catch let err as OmiseError {
            return performCallback(.fail(err))
        } catch let err as DecodingError {
            return performCallback(.fail(.other(err)))
        } catch let err as NSError {
            return performCallback(.fail(.other(err)))
        }
    }
    
    fileprivate func performCallback(_ result: Failable<TResult>) {
        guard let cb = callback else { return }
        client.operationQueue.addOperation { cb(result) }
    }
}


protocol AdditionalFixtureData {
    var fixtureFileSuffix: String? { get }
}

extension Omise.APIEndpoint {
    var fixtureFilePath: String {
        guard let components = URLComponents(url: makeURL(), resolvingAgainstBaseURL: true), let hostname = components.host else {
            preconditionFailure("Invalid URL")
        }
        
        let filePath =  pathComponents.reduce(hostname) { (path: String, segment: String) -> String in
            return ((path as NSString).appendingPathComponent(segment)) as String
        }
        
        let fixtureFileSuffix: String?
        switch parameter {
        case .get((let query as (APIURLQuery & AdditionalFixtureData)?)):
            fixtureFileSuffix = query?.fixtureFileSuffix
        case .head((let query as (APIURLQuery & AdditionalFixtureData)?)):
            fixtureFileSuffix = query?.fixtureFileSuffix
            
        case .post((let query as (APIQuery & AdditionalFixtureData)?)):
            fixtureFileSuffix = query?.fixtureFileSuffix
        case .patch((let query as (APIQuery & AdditionalFixtureData)?)):
            fixtureFileSuffix = query?.fixtureFileSuffix
        
        default:
            fixtureFileSuffix = nil
        }
        
        var filename = filePath
        if let fixtureFileSuffix = fixtureFileSuffix {
            filename += "-\(fixtureFileSuffix)"
        }
        filename += "-" + parameter.method.lowercased()
        return (filename as NSString).appendingPathExtension("json")! as String
    }
}


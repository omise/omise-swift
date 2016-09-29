import Foundation
import Omise


class FixtureClient: Client {
    let operationQueue: OperationQueue = OperationQueue()
    
    let fixturesDirectoryURL: URL
    
    public override init(config: Config) {
        let bundle = Bundle(for: FixtureClient.self)
        self.fixturesDirectoryURL = bundle.url(forResource: "Fixtures", withExtension: nil)!
        
        super.init(config: config)
    }

    override func call<TResult: OmiseObject>(_ operation: Omise.Operation<TResult>, callback: Omise.Operation<TResult>.Callback?) -> Request<TResult>? {
        do {
            let req: FixtureRequest<TResult> = FixtureRequest(client: self, operation: operation, callback: callback)
            return try req.start()
        } catch let err as NSError {
            operationQueue.addOperation() { callback?(.fail(.io(err))) }
        } catch let err as OmiseError {
            operationQueue.addOperation() { callback?(.fail(err)) }
        }
        
        return nil
    }
}


class FixtureRequest<TResult: OmiseObject>: Request<TResult> {
    var fixtureClient: FixtureClient? {
        return client as? FixtureClient
    }
    
    func start() throws -> Self {
        let fixtureFilePath = operation.fixtureFilePath
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
            return performCallback(.fail(.io(err as NSError)))
        }
        
        guard let data = data else {
            return performCallback(.fail(.unexpected("empty response.")))
        }
        
        do {
            let result: TResult = try OmiseSerializer.deserialize(data)            
            return performCallback(.success(result))
        } catch let err as NSError {
            return performCallback(.fail(.io(err)))
        } catch let err as OmiseError {
            return performCallback(.fail(err))
        }
    }
    
    fileprivate func performCallback(_ result: Failable<TResult>) {
        guard let cb = callback else { return }
        client.config.callbackQueue.addOperation { cb(result) }
    }
}

extension Omise.Operation {
    var fixtureFilePath: String {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let hostname = components.host else {
            preconditionFailure("Invalid URL")
        }
        
        let filePath =  pathComponents.reduce(hostname) { (path: String, segment: String) -> String in
            return ((path as NSString).appendingPathComponent(segment)) as String
        }
        
        return (filePath + "-" + method.lowercased() as NSString).appendingPathExtension("json")! as String
    }
}


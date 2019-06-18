/*: playground-setup
 We will be making background network requests in this QuickStart,
 so we need to first setup our Playground page to handle that:
 */
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/*: getting-started
 ---
 
 # Getting Started
 
 Start by making sure you can import the `Omise` module into your codebase.
 Follow Carthage's [Getting Started](https://github.com/Carthage/Carthage#getting-started) guide
 to incorporate this library into your application. The Omise-swift module is compatible with both iOS and OSX target.
 
 You will also need a set of [API keys](https://dashboard.omise.co/test/api-keys) in order to talk to
 the [Omise API](https://www.omise.co/docs). If you have not done so already,
 please sign up at [https://omise.co](https://omise.co) and check the Keys section to obtain your keys.
 */
import Omise // <-- Make sure this works first by building the OmiseSwiftOSX target.

let publicKey = "<#Your public key here#>" // <-- Change to your keys to see result in playground!
let secretKey = "<#Your secret key here#>"


/*:
 ## Create an instance of `APIClient`
 
 An instance of `Omise.APIClient` is required to perform any operations to Omise APIs.
 You can supply an `Omise.APIConfiguration` to the initializer of `Omise.APIClient`.
 */
let client = APIClient(
    config: APIConfiguration(key: AnyAccessKey(secretKey)))

/*:
 ---
 
 ## Calling Omise APIs
 
 Use API methods on model classes to call Omise APIs. Supply a callback method to receive the result.
 API calls will result is an enum with two states, `.success` and `.failure`.
 For example, to retrieve current account:
 
 ````
 Account.retrieve(using: client) { (result) in
    switch result {
    case let .success(account):
        // handle account
 
    case let .failure(err):
        // handle failure
    }
 }
 ````
 */
Account.retrieve(using: client) { (result) in
    switch result {
    case let .success(account):
        print("account: \(account.email)")
    case let .failure(err):
        print("error: \(err)")
    }
}

Balance.retrieve(using: client) { (result) in
    switch result {
    case let .success(balance):
        print("money: \(balance.transferableValue.amount)")
    case let .failure(err):
        print("error: \(err)")
    }
}

/*:
 Some APIs require specifying additional parameters, these are usually named after the models with
 a `APIParams` suffix and you can supply them to API methods using the `params:` parameter.
 
 ````
 let params = TokenParams()
 params.number = "4242424242424242"
 params.name = "Example"
 
 Token.create(using: client, params: params) { (result) in
    // ...
 }
 ````
 */
func createToken() {
    let params = TokenParams(number: "4242424242424242", name: "Omise Appleseed",
                             expiration: (10, 2020), securityCode: "123")
    
    Token.create(using: client, usingKey: AnyAccessKey(publicKey), params: params) { (result) in
        switch result {
        case let .success(token):
            print("created token: \(token.id)")
            createCharge(with: token)
            
        case let .failure(err):
            print("error: \(err)")
        }
    }
}

func createCharge(with token: Token) {
    let currency = Currency.thb
    let params = ChargeParams(value: Value(amount: currency.convert(toSubunit: 1000.00),
                                           currency: currency), cardID: token.id)
    
    Charge.create(using: client, params: params) { (result) in
        switch result {
        case let .success(charge):
            print("created charge: \(charge.id) - \(charge.value.amount)")
            createRefundOnCharge(charge, amount: currency.convert(toSubunit: 500.00))
            
        case let .failure(err):
            print("error: \(err)")
        }
    }
}

/*:
 ### Nested APIS
 
 Some APIs, such as the Refund API, require specifying a charge id. You can call them by supplying
 an instance of the parent object using the `parent` parameter like so:
 
 ````
 Refund.list(using: client, parent: charge) { (result) in
    // ...
 }
 ````
 
 Or alternatively, you can call the related methods on the parent instance directly:
 
 ````
 charge.listRefunds(using: client) { (result) in
    // ...
 }
 ````
 */
func createRefundOnCharge(_ charge: Charge, amount: Int64) {
    let params = RefundParams(amount: amount, void: false)
    
    charge.createRefund(using: client, params: params) { (result) in
        switch result {
        case let .success(refund):
            print("created refund: \(refund.id)")
            
        case let .failure(err):
            print("error: \(err)")
        }
    }
    
    Refund.create(using: client, parent: charge, params: params) { (result) in
        switch result {
        case let .success(result):
            print("created refund: \(result.id)")
            
        case let .failure(err):
            print("error: \(err)")
        }
    }
}

createToken()

/*: playground-setup
 
 We will be making background network requests in this QuickStart, so we need to first setup our Playground page to handle that:
 */
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

/*: getting-started
 ---
 
 # Getting Started
 
 Start by making sure you can import the `Omise` module into your codebase. Follow Carthage's [Getting Started](https://github.com/Carthage/Carthage#getting-started) guide to incorporate this library into your application. The Omise-swift module is compatible with both iOS and OSX target.
 */
import Omise // <-- Make sure this works first.

/*: configuration
 
 You will need a set of [API keys](https://dashboard.omise.co/test/api-keys) in order to talk to the [Omise API](https://www.omise.co/docs). If you have not done so already, please sign up at https://omise.co and click the aforementioned link to obtain your keys.
 */
let publicKey = "pkey_test_change_me" // <-- Change to your keys to see result in playground!
let secretKey = "skey_test_change_me"

/*:
 Once you have the API keys, there are two ways to use the `Omise` module.
 
 1. Using the default client, by configuring the `Omise.Default` class, like so:
 */
Default.config = Config(
    publicKey: publicKey,
    secretKey: secretKey
)

/*:
 2. Or by using custom client instance, by creating a new `Omise.Client` directly:
 */
let customClient = Client(
    config: Config(
        publicKey: publicKey,
        secretKey: secretKey
    )
)

/*:
 ---
 
 ## Calling Omise APIs
 
 Use the API methods on the model classes to invoke our APIs. For example, to retrieve current account and current balance:
 */
Account.retrieve { (result) in
    switch result {
    case let .Success(account):
        print("account: \(account.email)")
    case let .Fail(err):
        print("error: \(err)")
    }
}

// Supply the `using:` parameter to use a custom client:
Account.retrieve(using: customClient) { (result) in
    switch result {
    case let .Success(account):
        print("account: \(account.email)")
    case let .Fail(err):
        print("error: \(err)")
    }
}

Balance.retrieve { (result) in
    switch result {
    case let .Success(balance):
        print("money: \(balance.available)")
    case let .Fail(err):
        print("error: \(err)")
    }
}

/*:
 Some APIs require specifying additional parameters, these are usually named after the models with a `Params` suffix and you can supply them to API methods using the `params:` parameter.
 */
func createToken() {
    let params = TokenParams()
    params.number = "4242424242424242"
    params.name = "Omise Appleseed"
    params.expirationMonth = 10
    params.expirationYear = 2020
    params.securityCode = "123"
    
    Token.create(params: params) { (result) in
        switch result {
        case let .Success(token):
            print("created token: \(token.id)")
            createChargeWithToken(token)
            
        case let .Fail(err):
            print("error: \(err)")
        }
    }
}

func createChargeWithToken(token: Token) {
    let params = ChargeParams()
    params.amount = 100000 // 1,000.00 THB
    params.currency = "THB"
    params.card = token.id
    
    Charge.create(params: params) { (result) in
        switch result {
        case let .Success(charge):
            print("created charge: \(charge.id)")
        case let .Fail(err):
            print("error: \(err)")
        }
    }
}

createToken()

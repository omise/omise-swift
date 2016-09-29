/*: playground-setup
 
 We will be making background network requests in this QuickStart, so we need to first setup our Playground page to handle that:
 */
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/*: getting-started
 ---
 
 # Getting Started
 
 Start by making sure you can import the `Omise` module into your codebase. Follow Carthage's [Getting Started](https://github.com/Carthage/Carthage#getting-started) guide to incorporate this library into your application. The Omise-swift module is compatible with both iOS and OSX target.
 
 You will also need a set of [API keys](https://dashboard.omise.co/test/api-keys) in order to talk to the [Omise API](https://www.omise.co/docs). If you have not done so already, please sign up at [https://omise.co](https://omise.co) and check the Keys section to obtain your keys.
 */
import Omise // <-- Make sure this works first.

let publicKey = "pkey_test_54n2xnlf7ua73b4tkcp" // <-- Change to your keys to see result in playground!
let secretKey = "skey_test_54n2xndg1o0sbp461hr"

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
 
 Use API methods on model classes to call Omise APIs. Supply a callback method to receive the result. API calls will result is an enum with two states, `.Success` and `.Fail`. For example, to retrieve current account:
 
 ````
 Account.retrieve { (result) in
    switch result {
    case let .Success(account):
        // handle account
 
    case let .Fail(err):
        // handle failure
    }
 }
 ````
 */
Account.retrieve { (result) in
    switch result {
    case let .Success(account):
        print("account: \(account.email ?? "(n/a)")")
    case let .Fail(err):
        print("error: \(err)")
    }
}

Balance.retrieve { (result) in
    switch result {
    case let .Success(balance):
        print("money: \(balance.available ?? 0)")
    case let .Fail(err):
        print("error: \(err)")
    }
}

/*:
 Supply the `using:` parameter to use a custom client:
 */
Account.retrieve(using: customClient) { (result) in
    switch result {
    case let .Success(account):
        print("account: \(account.email ?? "(n/a)")")
    case let .Fail(err):
        print("error: \(err)")
    }
}

/*:
 Some APIs require specifying additional parameters, these are usually named after the models with a `Params` suffix and you can supply them to API methods using the `params:` parameter.
 
 ````
 let params = TokenParams()
 params.number = "4242424242424242"
 params.name = "Example"
 
 Token.create(params: params) { (result) in
    // ...
 }
 ````
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
            print("created token: \(token.id ?? "(n/a)")")
            createChargeWithToken(token)
            
        case let .Fail(err):
            print("error: \(err)")
        }
    }
}

func createChargeWithToken(token: Token) {
    let params = ChargeParams()
    let currency = Currency.THB
    params.amount = currency.convertToSubunit(1000.00) // 1,000.00 THB
    params.currency = currency
    params.card = token.id
    
    Charge.create(params: params) { (result) in
        switch result {
        case let .Success(charge):
            print("created charge: \(charge.id ?? "(n/a)") - \(charge.amount)")
            createRefundOnCharge(charge, amount: currency.convertToSubunit(500.00))
            
        case let .Fail(err):
            print("error: \(err)")
        }
    }
}

/*:
 ### Nested APIS
 
 Some APIs, such as the Refund API, require specifying a charge id. You can call them by supplying an instance of the parent object using the `parent` parameter like so:
 
 ````
 let charge = Charge()
 charge.id = "chrg_test_123"
 
 Refund.list(parent: charge) { (result) in
    // ...
 }
 ````
 
 Or alternatively, you can call the related methods on the parent instance directly:
 
 ````
 let charge = Charge()
 charge.id = "chrg_test_123"
 
 charge.listRefunds { (result) in
    // ...
 }
 ````
 */
func createRefundOnCharge(charge: Charge, amount: Int64) {
    let params = RefundParams()
    params.amount = amount / 2
    params.void = false
    
    charge.createRefund(params: params) { (result) in
        switch result {
        case let .Success(refund):
            print("created refund: \(refund.id ?? "(n/a)")")
            
        case let .Fail(err):
            print("error: \(err)")
        }
    }
    
    Refund.create(parent: charge, params: params) { (result) in
        switch result {
        case let .Success(result):
            print("created refund: \(result.id ?? "(n/a)")")
            
        case let .Fail(err):
            print("error: \(err)")
        }
    }
}

createToken()

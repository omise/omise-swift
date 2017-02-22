import Foundation

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif


// We provide the banks information file in a JSON file format.
// This JSON's keys are the country code of supported banks and 
// values are maps from the bank's ID to a JSON dictionary containing bank's information
// [ "th": [ "test": [ /* bank's information */ ] ] ]
private let banks: [String: [String: JSONDictionary]] = {
    let bundle = Bundle(for: APIClient.self)
    guard let bankJSONFileURL = bundle.url(forResource: "banks", withExtension: "json"),
        let data = try? Data(contentsOf: bankJSONFileURL),
        let json = try? JSONSerialization.jsonObject(with: data),
        let bankData = json as? [String: [String: JSONDictionary]]  else {
            return [:]
    }
    
    return bankData
}()

// A dictionary where key is a bank's ID and value is the country code where the bank is registered.
private let bankCountryCodeMap: [String: String] = {
    var countryCodes: [String: String] = [:]
    
    banks.forEach({ (countryCode, banks) in
        banks.keys.forEach({ code in
            countryCodes[code] = countryCode
        })
    })
    
    return countryCodes
}()


// A dictionary where key is a bank's ID and value is a bank's information
private let bankData: [String: JSONDictionary] = {
    var data: [String: JSONDictionary] = [:]
    banks.flatMap({ $0.1 }).forEach({
        data[$0.0] = $0.1
    })
    return data
}()

public struct Bank {
    public let bankID: String
    public let code: String
    
    public let countryCode: String?
    public let branchCode: String?
    public let preferredColor: Color?
    
    public let offcialName: String?
    public let name: String
    
    public init?(bankID: String, branchCode: String?) {
        guard let data = bankData[bankID], let countryCode = bankCountryCodeMap[bankID],
            let code = data["code"] as? String else {
            return nil
        }
        
        self.bankID = bankID
        self.code = code
        
        self.countryCode = countryCode
        self.branchCode = branchCode
        
        self.offcialName = data["offcial_name"] as? String
        self.name = (data["nice_name"] as? String) ?? bankID
        
        self.preferredColor = (data["color"] as? String).flatMap(Color.init(hexString:))
    }
}


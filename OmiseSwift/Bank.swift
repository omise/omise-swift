import Foundation

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif


private let banks: [String: [String: [String: Any]]] = {
    let bundle = Bundle(for: APIClient.self)
    guard let bankJSONFileURL = bundle.url(forResource: "banks", withExtension: "json"),
        let data = try? Data(contentsOf: bankJSONFileURL),
        let json = try? JSONSerialization.jsonObject(with: data),
        let bankData = json as? [String: [String: [String: Any]]]  else {
            return [:]
    }
    
    return bankData
}()

private let bankCountryCodeMap: [String: String] = {
    var countryCodes: [String: String] = [:]
    
    banks.forEach({ (countryCode, banks) in
        banks.keys.forEach({ code in
            countryCodes[code] = countryCode
        })
    })
    
    return countryCodes
}()

private let bankData: [String: [String: Any]] = {
    var data: [String: [String: Any]] = [:]
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


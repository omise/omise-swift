import Foundation
#if os(iOS)
    import UIKit
    public typealias Color = UIColor
 #elseif os(macOS)
    import AppKit
    public typealias Color = NSColor
#endif


func omiseWarn(_ message: String) {
    print("[omise-swift] WARN: \(message)")
}

public typealias JSONDictionary = [String: Any]

public extension Color {
    convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        guard hexString.hasPrefix("#") else {
            return nil
        }
        
        let start = hexString.index(hexString.startIndex, offsetBy: 1)
        let hexColor = String(hexString[start...])
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        
        guard scanner.scanHexInt64(&hexNumber) else {
            return nil
        }
        
        switch hexColor.count {
        case 8:
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
            
            self.init(red: r, green: g, blue: b, alpha: a)
        case 6:
            r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            b = CGFloat((hexNumber & 0x0000ff)) / 255
            
            self.init(red: r, green: g, blue: b, alpha: 1.0)

        default:
            return nil
        }
    }
}


extension Dictionary {
    static func makeFlattenDictionaryFrom(_ values: ([Key: Value?])) -> Dictionary<Key, Value> {
        return Dictionary(uniqueKeysWithValues: values.flatMap({ element -> (Key, Value)? in
            if let value = element.value {
                return (element.key, value)
            } else {
                return nil
            }
        }))
    }
}

func deserializeData<TObject: OmiseObject>(_ data: Data) throws -> TObject {
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .iso8601
    return try jsonDecoder.decode(TObject.self, from: data)
}

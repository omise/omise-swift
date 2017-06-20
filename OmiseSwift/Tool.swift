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
        
        if hexString.hasPrefix("#") {
            let start = hexString.characters.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else if hexColor.characters.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff)) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1.0)
                    return
                }
            }
        }
        
        return nil
    }
}


extension Dictionary {
    static func makeFlattenDictionaryFrom(_ values: ([Key: Value?])) -> Dictionary<Key, Value> {
        let values = values.flatMap({ element -> (Key, Value)? in
            if let value = element.value {
                return (element.key, value)
            } else {
                return nil
            }
        })
        
        var dictionary = Dictionary<Key, Value>(minimumCapacity: values.count)
        for (key, value) in values {
            dictionary[key] = value
        }
        return dictionary
    }
}


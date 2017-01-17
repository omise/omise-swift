import Foundation

func omiseWarn(_ message: String) {
    print("[omise-swift] WARN: \(message)")
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


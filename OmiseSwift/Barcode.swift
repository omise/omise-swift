import Foundation


public struct ScannableBarcode: Equatable, Codable {
    public let object: String
    public let type: BarcodeType
    
    public let image: Document
    
    public enum BarcodeType: String, Codable {
        case qr
    }
}

import Foundation
import AppKit

public struct DynamicDesktop {
    public let images: [Image]
    
    public init(_ tuples: (image: NSImage, altitude: Double, azimuth: Double)...) {
        var images: [Image] = []
        for case let (index, tuple) in tuples.enumerated() {
            let image = Image(cgImage: tuple.image.cgImage!, metadata: DynamicDesktop.Image.Metadata(index: index, altitude: tuple.altitude, azimuth: tuple.azimuth))
            images.append(image)
        }
        
        self.images = images
    }
    
    public struct Image {
        public let cgImage: CGImage
        public let metadata: Metadata
        
        public struct Metadata: Codable {
            public let index: Int
            public let altitude: Double
            public let azimuth: Double
      
            
            private enum CodingKeys: String, CodingKey {
                case index = "i"
                case altitude = "a"
                case azimuth = "z"
            }
        }
    }
    
    public func base64EncodedMetadata() throws -> String {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        
        let binaryPropertyListData = try encoder.encode(self)
        return binaryPropertyListData.base64EncodedString()
    }
}

extension DynamicDesktop: Encodable {
    private enum CodingKeys: String, CodingKey {
        case ap, si
    }
    
    private enum NestedCodingKeys: String, CodingKey {
        case d, l
    }
    
    public func encode(to encoder: Encoder) throws {
        var keyedContainer = encoder.container(keyedBy: CodingKeys.self)
        var nestedKeyedContainer = keyedContainer.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .ap)
        
        // FIXME: Unsure what `l` and `d` keys indicate
        try nestedKeyedContainer.encode(0, forKey: .l)
        try nestedKeyedContainer.encode(self.images.count, forKey: .d)
        
        var unkeyedContainer = keyedContainer.nestedUnkeyedContainer(forKey: .si)
        for image in self.images {
            try unkeyedContainer.encode(image.metadata)
        }
    }
}

import Foundation
import CoreGraphics

// macOS 10.14 Mojave Required
let url = URL(fileURLWithPath: "/Library/Desktop Pictures/Mojave.heic")
let source = CGImageSourceCreateWithURL(url as CFURL, nil)!

let metadata = CGImageSourceCopyMetadataAtIndex(source, 0, nil)!
let tags = CGImageMetadataCopyTags(metadata) as! [CGImageMetadataTag]
for tag in tags {
    guard let name = CGImageMetadataTagCopyName(tag) as? String,
        let value = CGImageMetadataTagCopyValue(tag) as? String
    else {
        continue
    }
    
    print(name, value)
    
    if name == "solar" {
        let data = Data(base64Encoded: value)!
        let propertyList = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        print(propertyList)
    }
}

let xmpData = CGImageMetadataCreateXMPData(metadata, nil)
let xmp = String(data: xmpData as! Data, encoding: .utf8)!
print(xmp)

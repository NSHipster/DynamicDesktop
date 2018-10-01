import Foundation
import AppKit
import AVFoundation

let outputURL = URL(fileURLWithPath: <#/path/to/output.heic#>)

// Mojave Day / Night in Resources
let dynamicDesktop = DynamicDesktop(
    (#imageLiteral(resourceName: "Mojave Day.jpg"), -0.3427528387535028, 270.9334057827345),
    (#imageLiteral(resourceName: "Mojave Night.jpg"), -10.23975864472505, 81.77588714480999)
)


guard let imageDestination = CGImageDestinationCreateWithURL(
                                outputURL as CFURL,
                                AVFileType.heic as CFString,
                                dynamicDesktop.images.count,
                                nil
                             ) else {
    fatalError("Error creating image destination")
}

for (index, image) in dynamicDesktop.images.enumerated() {
    if index == 0 {
        let imageMetadata = CGImageMetadataCreateMutable()
        guard let tag = CGImageMetadataTagCreate(
                            "http://ns.apple.com/namespace/1.0/" as CFString,
                            "apple_desktop" as CFString,
                            "solar" as CFString,
                            .string,
                            try! dynamicDesktop.base64EncodedMetadata() as CFString
                        ),
            CGImageMetadataSetTagWithPath(
                imageMetadata, nil, "xmp:solar" as CFString, tag
            )
        else {
            fatalError("Error creating image metadata")
        }
        
        CGImageDestinationAddImageAndMetadata(imageDestination, image.cgImage, imageMetadata, nil)
    } else {
        CGImageDestinationAddImage(imageDestination, image.cgImage, nil)
    }
}

guard CGImageDestinationFinalize(imageDestination) else {
    fatalError("Error finalizing image")
}



let output = NSImage(contentsOf: outputURL)

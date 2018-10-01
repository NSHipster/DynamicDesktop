import Foundation
import CoreLocation

// Apple Park, Cupertino, CA
let location = CLLocation(latitude: 37.3327, longitude: -122.0053)
let time = Date()

do {
    let position = solarPosition(for: location, at: time)
    print("Current Solar Position:")
    print("\(position.azimuth)° Az / \(position.elevation)° El")
    print("")
}

print("Solar Positions for \(DateFormatter.localizedString(from: time, dateStyle: .medium, timeStyle: .none)):")

for time in Calendar.current.dayInterval(for: time).striding(by: 60 * 15)
{
    let position = solarPosition(for: location, at: time)
    position.elevation
    position.azimuth

    print("\(DateFormatter.localizedString(from: time, dateStyle: .none, timeStyle: .short)): \(position.azimuth) \t /  \(position.elevation)")
}


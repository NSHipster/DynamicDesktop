import Foundation
import CoreLocation

func radians(degrees: CLLocationDegrees) -> Double {
    return .pi * degrees / 180.0
}

func degrees(radians: Double) -> CLLocationDegrees {
    return 180 * radians / .pi
}

public typealias SolarPosition = (elevation: CLLocationDegrees, azimuth: CLLocationDegrees)

public func solarPosition(for location: CLLocation,
                          at time: Date,
                          with calendar: Calendar = .current) -> SolarPosition {
    let elapsedJulianDays = time.timeIntervalSince(.J2000) / numberOfSecondsPerDay
    
    let ω = 2.1429 - 0.0010394594 * elapsedJulianDays
    let meanLongitude = 4.8950630 + 0.017202791698 * elapsedJulianDays
    let meanAnomaly = 6.2400600 + 0.0172019699 * elapsedJulianDays
    
    
    let eclipticLongitude = meanLongitude + 0.03341607 * sin(meanAnomaly) + 0.00034894 * sin(2 * meanAnomaly) - 0.0001134 - 0.0000203 * sin(ω)
    
    let eclipticObliquity = 0.4090928 - 6.2140e-9 * elapsedJulianDays + 0.0000396 * cos(ω)
    
    var rightAscension = atan2(cos(eclipticObliquity) * sin(eclipticLongitude), cos(eclipticLongitude))
    if rightAscension < 0 {
        rightAscension += (2.0 * .pi)
    }
    
    let declination = asin(sin(eclipticObliquity) * sin(eclipticLongitude))
    
    let latitude = radians(degrees: location.coordinate.latitude)
    let longitude = radians(degrees: location.coordinate.longitude)
    
    let greenwichMeanSiderealTime = 6.6974243242 + 0.0657098283 * elapsedJulianDays + calendar.fractionalHours(for: time)
    let localMeanSiderealTime = (greenwichMeanSiderealTime * 15 + longitude) * (.pi / 180.0)
    let hourAngle = localMeanSiderealTime - rightAscension
    
    let elevation = asin(cos(latitude) * cos(hourAngle) * cos(declination) +
        sin(declination) * sin(latitude))
    
    var azimuth = atan2(-sin(hourAngle), tan(declination) * cos(latitude) - sin(latitude) * cos(hourAngle))
    if azimuth < 0 {
        azimuth += (.pi * 2.0)
    }
    
    return (degrees(radians: elevation), degrees(radians: azimuth))
}

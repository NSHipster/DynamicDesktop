import Foundation

public let numberOfSecondsPerDay: TimeInterval = 60 * 60 * 24

extension Calendar {
    public func dayInterval(for date: Date) -> DateInterval {
        let beginningOfDay = self.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
        return DateInterval(start: beginningOfDay, duration: numberOfSecondsPerDay - 1)
    }
}

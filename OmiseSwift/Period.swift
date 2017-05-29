import Foundation


public enum Period {
    case daily
    case weekly(Set<Weekday>)
    case monthly(MonthlyPeriodRule)
    
    public enum Weekday: Equatable {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
    }
    
    public enum MonthlyPeriodRule {
        public struct DayOfMonth: RawRepresentable, Hashable, ExpressibleByIntegerLiteral {
            public typealias RawValue = Int
            public let day: Int
            public var rawValue: Int {
                return day
            }
            
            public init?(rawValue: Int) {
                guard 1...28 ~= rawValue else {
                    return nil
                }
                self.day = rawValue
            }
            
            public init(integerLiteral value: Int) {
                self.init(rawValue: value)!
            }
            
            public var hashValue: Int {
                return day.hashValue
            }
        }
        public enum Ordinal: Equatable {
            case first
            case second
            case third
            case fourth
            case last
        }
        case daysOfMonth(Set<DayOfMonth>)
        case weekdayOfMonth(ordinal: Ordinal, weekday: Weekday)
    }
}


extension Period: Equatable {
    init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let period = json["period"] as? String else {
                return nil
        }
        
        let onValues = json["on"] as? [String: Any]
        
        let onWeekdays = (onValues?["weekdays"] as? [String])?.flatMap({ Weekday(weekdayString: $0) })
        let monthlyRule: MonthlyPeriodRule?
        
        let onMonthdays = (onValues?["days_of_month"] as? [Int])?.flatMap({ MonthlyPeriodRule.DayOfMonth(rawValue: $0) })
        let onWeekdayOfMonth = (onValues?["weekday_of_month"] as? String)
            .flatMap({ value -> (MonthlyPeriodRule.Ordinal, Weekday)? in
                let splitted = value.components(separatedBy: "_")
                guard splitted.count == 2,
                    let ordinal = splitted.first.flatMap(MonthlyPeriodRule.Ordinal.init(ordinalString:)),
                    let weekday = splitted.last.flatMap(Weekday.init(weekdayString:)) else {
                        return nil
                }
                
                return (ordinal, weekday)
            })
        
        switch (onMonthdays, onWeekdayOfMonth) {
        case (let onMonthdays?, nil):
            monthlyRule = MonthlyPeriodRule.daysOfMonth(Set(onMonthdays))
        case (nil, let onWeekdayOfMonth?):
            monthlyRule = MonthlyPeriodRule.weekdayOfMonth(ordinal: onWeekdayOfMonth.0, weekday: onWeekdayOfMonth.1)
        default:
            monthlyRule = nil
        }
        
        switch (period, onWeekdays, monthlyRule) {
        case ("day", nil, nil):
            self = .daily
        case ("week", let onWeekdays?, nil):
            self = .weekly(Set(onWeekdays))
        case ("month", nil, let monthlyRule?):
            self = .monthly(monthlyRule)
        default:
            return nil
        }
    }
    
    public static func ==(lhs: Period, rhs: Period) -> Bool {
        switch (lhs, rhs) {
        case (.daily, .daily):
            return true
        case (.weekly, .weekly):
            return true
        case (.monthly, .monthly):
            return true
        default:
            return false
        }
    }
}


extension Period.MonthlyPeriodRule: Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Period.MonthlyPeriodRule, rhs: Period.MonthlyPeriodRule) -> Bool {
        switch (lhs, rhs) {
        case (.daysOfMonth(let lhsDays), .daysOfMonth(let rhsDays)):
            return lhsDays == rhsDays
        case (.weekdayOfMonth(let lhs), .weekdayOfMonth(let rhs)):
            return lhs.ordinal == rhs.ordinal && lhs.weekday == rhs.weekday
        default:
            return false
        }
    }
}

extension Period.Weekday {
    init?(weekdayString: String) {
        switch weekdayString.lowercased()  {
        case "monday":
            self = .monday
        case "tuesday":
            self = .tuesday
        case "wednesday":
            self = .wednesday
        case "thursday":
            self = .thursday
        case "friday":
            self = .friday
        case "saturday":
            self = .saturday
        case "sunday":
            self = .sunday
        default:
            return nil
        }
    }
}

extension Period.MonthlyPeriodRule.Ordinal {
    init?(ordinalString: String) {
        switch ordinalString.lowercased()  {
        case "1st":
            self = .first
        case "2nd":
            self = .second
        case "3rd":
            self = .third
        case "4th":
            self = .fourth
        case "last":
            self = .last
        default:
            return nil
        }
    }
}





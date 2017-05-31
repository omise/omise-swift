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

extension Period {
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
    
    public var json: JSONAttributes {
        let periodString: String
        let ruleJSON: [String: Any]
        
        switch self {
        case .daily:
            periodString = "day"
            ruleJSON = [:]
        case .weekly(let weekdays):
            periodString = "week"
            ruleJSON = [
                "weekdays": weekdays.sorted(by: { (first, second) -> Bool in
                    switch (first, second) {
                    case (.monday, _):
                        return true
                    case (.sunday, _):
                        return false
                    case (.tuesday, .monday):
                        return false
                    case (.tuesday, _):
                        return true
                    case (.saturday, .sunday):
                        return true
                    case (.saturday, _):
                        return false
                        
                    case (.wednesday, .monday), (.wednesday, .tuesday):
                        return false
                    case (.wednesday, _):
                        return true
                        
                    case (.friday, .saturday), (.friday, .sunday):
                        return true
                    case (.friday, _):
                        return false
                        
                    case (.thursday, .monday), (.thursday, .tuesday), (.thursday, .wednesday), (.thursday, .thursday):
                        return true
                    case (.thursday, .friday), (.thursday, .saturday), (.thursday, .sunday):
                        return false
                    }
                }).map({ $0.apiValue })
            ]
        case .monthly(let monthlyRule):
            periodString = "month"
            switch monthlyRule {
            case .daysOfMonth(let daysOfMonth):
                ruleJSON = [
                    "days_of_month": daysOfMonth.map({ $0.rawValue }).sorted()
                ]
            case .weekdayOfMonth(ordinal: let ordinal, weekday: let weekday):
                ruleJSON = [
                    "weekday_of_month": "\(ordinal.apiValue)_\(weekday.apiValue.lowercased())"
                ]
            }
        }
        
        return Dictionary.makeFlattenDictionaryFrom([
            "period": periodString,
            "on": ruleJSON
            ])
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
    
    
    fileprivate var apiValue: String {
        switch self {
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        case .sunday:
            return "Sunday"
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
    
    fileprivate var apiValue: String {
        switch self {
        case .first:
            return "1st"
        case .second:
            return "2nd"
        case .third:
            return "3rd"
        case .fourth:
            return "4th"
        case .last:
            return "last"
        }
    }
}





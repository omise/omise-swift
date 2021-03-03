import Foundation


public enum Period {
    case daily
    case weekly(Set<Weekday>)
    case monthly(MonthlyPeriodRule)
    case unknown(String, [String: Any]?)
    
    public enum Weekday: String, Equatable, Codable {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
    }
    
    public enum MonthlyPeriodRule: Equatable {
        public struct DayOfMonth: RawRepresentable, Hashable, ExpressibleByIntegerLiteral {
            public typealias RawValue = Int
            public let day: Int
            public var rawValue: Int {
                return day
            }
            
            public init?(rawValue: Int) {
                guard -31...31 ~= rawValue else {
                    return nil
                }
                self.day = rawValue
            }
            
            public init(integerLiteral value: Int) {
                self.init(rawValue: value)!
            }
            
            public func hash(into hasher: inout Hasher) {
                hasher.combine(day)
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
        case (.weekly(let lhsWeekDays), .weekly(let rhsWeekDays)):
            return lhsWeekDays == rhsWeekDays
        case (.monthly(let lhsMonthlyRule), .monthly(let rhsMonthlyRule)):
            return lhsMonthlyRule == rhsMonthlyRule
        default:
            return false
        }
    }
}

extension Period: Codable {
    private enum CodingKeys: String, CodingKey {
        case period
        case on
        enum RuleCodingKeys: String, CodingKey {
            case weekdays
            case daysOfMonth = "days_of_month"
            case weekdayOfMonth = "weekday_of_month"
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .daily:
            try container.encode("day", forKey: .period)
            var _ = container.nestedContainer(keyedBy: CodingKeys.RuleCodingKeys.self, forKey: .on)
        case .weekly(let weekDays):
            try container.encode("week", forKey: .period)
            var ruleContainer = container.nestedContainer(keyedBy: CodingKeys.RuleCodingKeys.self, forKey: .on)
            var weekDaysContainers = ruleContainer.nestedUnkeyedContainer(forKey: .weekdays)
            try weekDaysContainers.encode(contentsOf:
                weekDays.sorted(by: { (first, second) -> Bool in
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
                }))
        case .monthly(let month):
            try container.encode("month", forKey: .period)
            var ruleContainer = container.nestedContainer(keyedBy: CodingKeys.RuleCodingKeys.self, forKey: .on)
            switch month {
            case .daysOfMonth(let daysOfMonth):
                var daysOfMonthContainers = ruleContainer.nestedUnkeyedContainer(forKey: .daysOfMonth)
                try daysOfMonthContainers.encode(contentsOf: daysOfMonth.map({ $0.rawValue }).sorted())
            case .weekdayOfMonth(ordinal: let ordinal, weekday: let weekday):
                try ruleContainer.encode(
                    "\(ordinal.apiValue)_\(weekday.apiValue.lowercased())", forKey: .weekdayOfMonth)
            }
        case .unknown(let value, let rules):
            try container.encode(value, forKey: .period)
            try container.encodeIfPresent(rules, forKey: .on)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let period = try container.decode(String.self, forKey: .period)
        
        let rules = try container.nestedContainer(keyedBy: CodingKeys.RuleCodingKeys.self, forKey: .on)
        let onWeekdays = try rules.decodeIfPresent(Array<Weekday>.self, forKey: .weekdays)
        let onMonthDays = try rules.decodeIfPresent(Array<MonthlyPeriodRule.DayOfMonth>.self, forKey: .daysOfMonth)
        let onWeekdayOfMonth: (MonthlyPeriodRule.Ordinal, Weekday)?
        
        do {
            if let onWeekdaysOfMonthValue = try rules.decodeIfPresent(String.self, forKey: .weekdayOfMonth) {
                let splitted = onWeekdaysOfMonthValue.components(separatedBy: "_")
                if splitted.count == 2,
                    let ordinal = splitted.first.flatMap(MonthlyPeriodRule.Ordinal.init(ordinalString:)),
                    let weekday = splitted.last.flatMap(Weekday.init(weekdayString:)) {
                    onWeekdayOfMonth = (ordinal, weekday)
                } else {
                    throw DecodingError.dataCorrupted(
                        DecodingError.Context(codingPath: decoder.codingPath,
                                              debugDescription: "Invalid Weekdays of month value"))
                }
            } else {
                onWeekdayOfMonth = nil
            }
        }
        
        let monthlyRule: MonthlyPeriodRule?
        switch (onMonthDays, onWeekdayOfMonth) {
        case (let onMonthDays?, nil):
            monthlyRule = MonthlyPeriodRule.daysOfMonth(Set(onMonthDays))
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
        case (let value, _, _):
            let rules = try container.decodeIfPresent(Dictionary<String, Any>.self, forKey: .on)
            self = .unknown(value, rules)
        }
    }
}

extension Period.MonthlyPeriodRule.DayOfMonth: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(Int.self)
        guard -31...31 ~= value else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: decoder.codingPath,
                                      debugDescription: "Invalid day of month value"))
        }
        self.day = value
    }
}

extension Period.MonthlyPeriodRule.Ordinal: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value.lowercased() {
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
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: decoder.codingPath,
                                      debugDescription: "Invalid day of month value"))
        }
    }
}

extension Period.Weekday {
    init?(weekdayString: String) {
        switch weekdayString.lowercased() {
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
            return "monday"
        case .tuesday:
            return "tuesday"
        case .wednesday:
            return "wednesday"
        case .thursday:
            return "thursday"
        case .friday:
            return "friday"
        case .saturday:
            return "saturday"
        case .sunday:
            return "sunday"
        }
    }
}

extension Period.MonthlyPeriodRule.Ordinal {
    init?(ordinalString: String) {
        switch ordinalString.lowercased() {
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

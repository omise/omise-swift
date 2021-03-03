import XCTest
@testable import Omise


class SchedulesOperationFixtureTests: FixtureTestCase {
    func testScheduleRetrieve() {
        let expectation = self.expectation(description: "Schedule result")
        
        let scheduleTestingID: DataID<Schedule<Charge>> = "schd_test_5fzpgks1yf8me0wabse"
        
        let request = Schedule<Charge>.retrieve(using: testClient, id: scheduleTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(schedule):
                let gregorianCalendar = Calendar(identifier: .gregorian)
                
                XCTAssertEqual(schedule.id, scheduleTestingID)
                XCTAssertEqual(schedule.location, "/schedules/schd_test_5fzpgks1yf8me0wabse")
                XCTAssertEqual(schedule.createdDate, dateFormatter.date(from: "2019-05-23T04:35:15Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.running)
                let expectedMonthlyRule = Period.MonthlyPeriodRule.daysOfMonth([27])
                XCTAssertEqual(schedule.period, Period.monthly(expectedMonthlyRule))
                XCTAssertEqual(schedule.startOnDateComponents,
                               DateComponents(calendar: gregorianCalendar, year: 2019, month: 5, day: 23))
                XCTAssertEqual(schedule.endOnDateComponents,
                               DateComponents(calendar: gregorianCalendar, year: 2020, month: 5, day: 23))
                
                XCTAssertEqual(schedule.scheduleData.amount, 1000000)
                XCTAssertEqual(schedule.scheduleData.customerID, "cust_test_5fz0olfpy32zadv96ek")
                
                let firstNextOccurrenceDate = gregorianCalendar.date(from:
                    DateComponents(calendar: gregorianCalendar, year: 2019, month: 5, day: 27))!
                let nextOccurrences = (0..<12).map({ (month) in
                    return gregorianCalendar.date(byAdding: .month, value: month, to: firstNextOccurrenceDate)
                        .flatMap({ gregorianCalendar.dateComponents([.calendar, .year, .month, .day], from: $0) })!
                })
                
                XCTAssertEqual(schedule.nextOccurrencesOnDateComponents, nextOccurrences)
                
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeScheduleRetrieve() throws {
        let defaultSchedule = try fixturesObjectFor(type: Schedule<Charge>.self,
                                                    dataID: "schd_test_5fzpgks1yf8me0wabse")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultSchedule)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedSchedule = try decoder.decode(Schedule<Charge>.self, from: encodedData)
        XCTAssertEqual(defaultSchedule.object, decodedSchedule.object)
        XCTAssertEqual(defaultSchedule.id, decodedSchedule.id)
        XCTAssertEqual(defaultSchedule.isLiveMode, decodedSchedule.isLiveMode)
        XCTAssertEqual(defaultSchedule.location, decodedSchedule.location)
        XCTAssertEqual(defaultSchedule.status, decodedSchedule.status)
        XCTAssertEqual(defaultSchedule.every, decodedSchedule.every)
        XCTAssertEqual(defaultSchedule.period, decodedSchedule.period)
        XCTAssertEqual(defaultSchedule.startOnDateComponents, decodedSchedule.startOnDateComponents)
        XCTAssertEqual(defaultSchedule.endOnDateComponents, decodedSchedule.endOnDateComponents)
        
        XCTAssertEqual(defaultSchedule.occurrences.total, decodedSchedule.occurrences.total)
        XCTAssertEqual(defaultSchedule.occurrences.object, decodedSchedule.occurrences.object)
        XCTAssertEqual(defaultSchedule.occurrences.from, decodedSchedule.occurrences.from)
        XCTAssertEqual(defaultSchedule.occurrences.to, decodedSchedule.occurrences.to)
        XCTAssertEqual(defaultSchedule.occurrences.limit, decodedSchedule.occurrences.limit)
        XCTAssertEqual(decodedSchedule.scheduleData.amount, decodedSchedule.scheduleData.amount)
        XCTAssertEqual(decodedSchedule.scheduleData.customerID, decodedSchedule.scheduleData.customerID)
        XCTAssertEqual(defaultSchedule.createdDate, decodedSchedule.createdDate)
        
        guard let defaultRecentNextOccurrenceDate = defaultSchedule.nextOccurrencesOnDateComponents.first,
            let decodedRecentNextOccurrenceDate = decodedSchedule.nextOccurrencesOnDateComponents.first else {
                XCTFail("Cannot get the recent next occurrence date")
                return
        }
        XCTAssertEqual(defaultRecentNextOccurrenceDate, decodedRecentNextOccurrenceDate)
        XCTAssertEqual(defaultSchedule.nextOccurrencesOnDateComponents.count,
                       decodedSchedule.nextOccurrencesOnDateComponents.count)
    }
    
    func testEveryDayChargeScheduleRetrieve() {
        let expectation = self.expectation(description: "Schedule result")
        
        let scheduleTestingID: DataID<Schedule<Charge>>  = "schd_test_5fzoyq0dpywer0738br"
        let request = Schedule<Charge>.retrieve(using: testClient, id: scheduleTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(schedule):
                let gregorianCalendar = Calendar(identifier: .gregorian)
                
                XCTAssertEqual(schedule.id, scheduleTestingID)
                XCTAssertEqual(schedule.location, "/schedules/schd_test_5fzoyq0dpywer0738br")
                XCTAssertEqual(schedule.createdDate, dateFormatter.date(from: "2019-05-23T03:44:31Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.running)
                XCTAssertEqual(schedule.period, Period.daily)
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startOnDateComponents,
                               DateComponents(calendar: gregorianCalendar, year: 2019, month: 5, day: 23))
                XCTAssertEqual(schedule.endOnDateComponents,
                               DateComponents(calendar: gregorianCalendar, year: 2020, month: 5, day: 23))
                
                XCTAssertEqual(schedule.scheduleData.value.amount, 100000)
                XCTAssertEqual(schedule.scheduleData.value.currency, Currency.thb)
                XCTAssertEqual(schedule.scheduleData.customerID, "cust_test_5fz0olfpy32zadv96ek")
                
                let firstNextOccurrenceDate = gregorianCalendar.date(
                    from: DateComponents(calendar: gregorianCalendar, year: 2019, month: 5, day: 24))!
                let nextOccurrences = (0..<30).map({ (day) in
                    return gregorianCalendar.date(byAdding: .day, value: day, to: firstNextOccurrenceDate)
                        .flatMap({ gregorianCalendar.dateComponents([.calendar, .year, .month, .day], from: $0) })!
                })
                
                XCTAssertEqual(schedule.nextOccurrencesOnDateComponents, nextOccurrences)
                
                let occurrences = schedule.occurrences
                XCTAssertEqual(occurrences.total, 1)
                if let firstOccurrence = occurrences.data.first {
                    XCTAssertEqual(firstOccurrence.id, "occu_test_5fzoyq0ejt05zhr38h7")
                    XCTAssertEqual(firstOccurrence.schedule.id, scheduleTestingID)
                    XCTAssertEqual(firstOccurrence.scheduledOnDateComponents,
                                   DateComponents(calendar: gregorianCalendar, year: 2019, month: 5, day: 23))
                    XCTAssertEqual(firstOccurrence.status, .successful)
                    XCTAssertEqual(firstOccurrence.processedDate, dateFormatter.date(from: "2019-05-23T03:44:32Z"))
                    XCTAssertEqual(firstOccurrence.result.id, "chrg_test_5fzoyq12bpn53cybws0")
                    XCTAssertEqual(firstOccurrence.createdDate, dateFormatter.date(from: "2019-05-23T03:44:31Z"))
                } else {
                    XCTFail("Failed to parse occurrences")
                }
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeEveryDayChargeScheduleRetrieve() throws {
        let defaultSchedule = try fixturesObjectFor(type: Schedule<Charge>.self,
                                                    dataID: "schd_test_5fzoyq0dpywer0738br")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultSchedule)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedSchedule = try decoder.decode(Schedule<Charge>.self, from: encodedData)
        XCTAssertEqual(defaultSchedule.object, decodedSchedule.object)
        XCTAssertEqual(defaultSchedule.id, decodedSchedule.id)
        XCTAssertEqual(defaultSchedule.isLiveMode, decodedSchedule.isLiveMode)
        XCTAssertEqual(defaultSchedule.location, decodedSchedule.location)
        XCTAssertEqual(defaultSchedule.status, decodedSchedule.status)
        XCTAssertEqual(defaultSchedule.every, decodedSchedule.every)
        XCTAssertEqual(defaultSchedule.period, decodedSchedule.period)
        XCTAssertEqual(defaultSchedule.startOnDateComponents, decodedSchedule.startOnDateComponents)
        XCTAssertEqual(defaultSchedule.endOnDateComponents, decodedSchedule.endOnDateComponents)
        
        XCTAssertEqual(defaultSchedule.scheduleData.value.amount, decodedSchedule.scheduleData.value.amount)
        XCTAssertEqual(defaultSchedule.scheduleData.value.currency, decodedSchedule.scheduleData.value.currency)
        XCTAssertEqual(defaultSchedule.scheduleData.customerID, decodedSchedule.scheduleData.customerID)
        
        XCTAssertEqual(defaultSchedule.createdDate, decodedSchedule.createdDate)
        
        guard let defaultRecentNextOccurrenceDate = defaultSchedule.nextOccurrencesOnDateComponents.first,
            let decodedRecentNextOccurrenceDate = decodedSchedule.nextOccurrencesOnDateComponents.first else {
                XCTFail("Cannot get the recent next occurrence date")
                return
        }
        XCTAssertEqual(defaultRecentNextOccurrenceDate, decodedRecentNextOccurrenceDate)
        XCTAssertEqual(defaultSchedule.nextOccurrencesOnDateComponents.count, decodedSchedule.nextOccurrencesOnDateComponents.count)
        
        XCTAssertEqual(defaultSchedule.occurrences.total, decodedSchedule.occurrences.total)
        XCTAssertEqual(defaultSchedule.occurrences.object, decodedSchedule.occurrences.object)
        XCTAssertEqual(defaultSchedule.occurrences.from, decodedSchedule.occurrences.from)
        XCTAssertEqual(defaultSchedule.occurrences.to, decodedSchedule.occurrences.to)
        XCTAssertEqual(defaultSchedule.occurrences.limit, decodedSchedule.occurrences.limit)
        XCTAssertEqual(defaultSchedule.occurrences.data.count, decodedSchedule.occurrences.data.count)
        
        guard let defaultRecentOccurrenceDate = defaultSchedule.occurrences.data.first,
            let decodedRecentOccurrenceDate = decodedSchedule.occurrences.data.first else {
                XCTFail("Cannot get the recent occurrence date")
                return
        }
        
        XCTAssertEqual(defaultRecentOccurrenceDate.object, decodedRecentOccurrenceDate.object)
        XCTAssertEqual(defaultRecentOccurrenceDate.isLiveMode, decodedRecentOccurrenceDate.isLiveMode)
        XCTAssertEqual(defaultRecentOccurrenceDate.id, decodedRecentOccurrenceDate.id)
        XCTAssertEqual(defaultRecentOccurrenceDate.location, decodedRecentOccurrenceDate.location)
        XCTAssertEqual(defaultRecentOccurrenceDate.schedule.id, decodedRecentOccurrenceDate.schedule.id)
        XCTAssertEqual(defaultRecentOccurrenceDate.processedDate, decodedRecentOccurrenceDate.processedDate)
        XCTAssertEqual(defaultRecentOccurrenceDate.status, decodedRecentOccurrenceDate.status)
        XCTAssertEqual(defaultRecentOccurrenceDate.result.id, decodedRecentOccurrenceDate.result.id)
        XCTAssertEqual(defaultRecentOccurrenceDate.createdDate, decodedRecentOccurrenceDate.createdDate)
    }
    
    func testEveryLastFridayOfMonthChargeScheduleRetrieve() {
        let expectation = self.expectation(description: "Schedule result")
        
        let scheduleTestingID: DataID<Schedule<Charge>>  = "schd_test_5fzoz616kap3j82u92b"
        let request = Schedule<Charge>.retrieve(using: testClient, id: scheduleTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(schedule):
                let gregorianCalendar = Calendar(identifier: .gregorian)
                
                XCTAssertEqual(schedule.id, scheduleTestingID)
                XCTAssertEqual(schedule.location, "/schedules/schd_test_5fzoz616kap3j82u92b")
                XCTAssertEqual(schedule.createdDate, dateFormatter.date(from: "2019-05-23T03:45:47Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.running)
                XCTAssertEqual(schedule.period, Period.monthly(.weekdayOfMonth(ordinal: .last, weekday: .friday)))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startOnDateComponents,
                               DateComponents(calendar: gregorianCalendar, year: 2019, month: 5, day: 23))
                XCTAssertEqual(schedule.endOnDateComponents,
                               DateComponents(calendar: gregorianCalendar, year: 2020, month: 5, day: 23))
                
                XCTAssertEqual(schedule.scheduleData.value.amount, 1000000)
                XCTAssertEqual(schedule.scheduleData.value.currency, Currency.thb)
                XCTAssertEqual(schedule.scheduleData.customerID, "cust_test_5fz0olfpy32zadv96ek")
                
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeEveryLastFridayOfMonthChargeScheduleRetrieve() throws {
        let defaultSchedule = try fixturesObjectFor(type: Schedule<Charge>.self,
                                                    dataID: "schd_test_5fzoz616kap3j82u92b")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultSchedule)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedSchedule = try decoder.decode(Schedule<Charge>.self, from: encodedData)
        XCTAssertEqual(defaultSchedule.object, decodedSchedule.object)
        XCTAssertEqual(defaultSchedule.id, decodedSchedule.id)
        XCTAssertEqual(defaultSchedule.isLiveMode, decodedSchedule.isLiveMode)
        XCTAssertEqual(defaultSchedule.location, decodedSchedule.location)
        XCTAssertEqual(defaultSchedule.status, decodedSchedule.status)
        XCTAssertEqual(defaultSchedule.every, decodedSchedule.every)
        XCTAssertEqual(defaultSchedule.period, decodedSchedule.period)
        XCTAssertEqual(defaultSchedule.startOnDateComponents, decodedSchedule.startOnDateComponents)
        XCTAssertEqual(defaultSchedule.endOnDateComponents, decodedSchedule.endOnDateComponents)
        
        XCTAssertEqual(defaultSchedule.scheduleData.value.amount, decodedSchedule.scheduleData.value.amount)
        XCTAssertEqual(defaultSchedule.scheduleData.value.currency, decodedSchedule.scheduleData.value.currency)
        XCTAssertEqual(defaultSchedule.scheduleData.customerID, decodedSchedule.scheduleData.customerID)
        
        XCTAssertEqual(defaultSchedule.createdDate, decodedSchedule.createdDate)
        
        XCTAssertEqual(defaultSchedule.nextOccurrencesOnDateComponents.count,
                       decodedSchedule.nextOccurrencesOnDateComponents.count)
        guard let defaultRecentNextOccurrenceDate = defaultSchedule.nextOccurrencesOnDateComponents.first,
            let decodedRecentNextOccurrenceDate = decodedSchedule.nextOccurrencesOnDateComponents.first else {
                XCTFail("Cannot get the recent next occurrence date")
                return
        }
        
        XCTAssertEqual(defaultRecentNextOccurrenceDate, decodedRecentNextOccurrenceDate)
    }
    
    func testEveryFirstMondayOfMonthChargeScheduleRetrieve() {
        let expectation = self.expectation(description: "Schedule result")
        
        let scheduleTestingID: DataID<Schedule<Charge>>  = "schd_test_5fzozh3os3a2lnjyni0"
        let request = Schedule<Charge>.retrieve(using: testClient, id: scheduleTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(schedule):
                let gregorianCalendar = Calendar(identifier: .gregorian)
                
                XCTAssertEqual(schedule.id, scheduleTestingID)
                XCTAssertEqual(schedule.location, "/schedules/schd_test_5fzozh3os3a2lnjyni0")
                XCTAssertEqual(schedule.createdDate, dateFormatter.date(from: "2019-05-23T03:46:40Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.running)
                XCTAssertEqual(schedule.period, Period.monthly(.weekdayOfMonth(ordinal: .first, weekday: .monday)))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startOnDateComponents,
                               DateComponents(calendar: gregorianCalendar, year: 2019, month: 5, day: 23))
                XCTAssertEqual(schedule.endOnDateComponents,
                               DateComponents(calendar: gregorianCalendar, year: 2020, month: 5, day: 23))
                
                XCTAssertEqual(schedule.scheduleData.value.amount, 1000000)
                XCTAssertEqual(schedule.scheduleData.value.currency, Currency.thb)
                XCTAssertEqual(schedule.scheduleData.customerID, "cust_test_5fz0olfpy32zadv96ek")
                
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeEveryFirstMondayOfMonthChargeScheduleRetrieve() throws {
        let defaultSchedule = try fixturesObjectFor(type: Schedule<Charge>.self,
                                                    dataID: "schd_test_5fzozh3os3a2lnjyni0")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultSchedule)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedSchedule = try decoder.decode(Schedule<Charge>.self, from: encodedData)
        XCTAssertEqual(defaultSchedule.object, decodedSchedule.object)
        XCTAssertEqual(defaultSchedule.id, decodedSchedule.id)
        XCTAssertEqual(defaultSchedule.isLiveMode, decodedSchedule.isLiveMode)
        XCTAssertEqual(defaultSchedule.location, decodedSchedule.location)
        XCTAssertEqual(defaultSchedule.status, decodedSchedule.status)
        XCTAssertEqual(defaultSchedule.every, decodedSchedule.every)
        XCTAssertEqual(defaultSchedule.period, decodedSchedule.period)
        XCTAssertEqual(defaultSchedule.startOnDateComponents, decodedSchedule.startOnDateComponents)
        XCTAssertEqual(defaultSchedule.endOnDateComponents, decodedSchedule.endOnDateComponents)
        
        XCTAssertEqual(defaultSchedule.scheduleData.value.amount, decodedSchedule.scheduleData.value.amount)
        XCTAssertEqual(defaultSchedule.scheduleData.value.currency, decodedSchedule.scheduleData.value.currency)
        XCTAssertEqual(defaultSchedule.scheduleData.customerID, decodedSchedule.scheduleData.customerID)
        
        XCTAssertEqual(defaultSchedule.createdDate, decodedSchedule.createdDate)
        
        XCTAssertEqual(defaultSchedule.nextOccurrencesOnDateComponents.count,
                       decodedSchedule.nextOccurrencesOnDateComponents.count)
        guard let defaultRecentNextOccurrenceDate = defaultSchedule.nextOccurrencesOnDateComponents.first,
            let decodedRecentNextOccurrenceDate = decodedSchedule.nextOccurrencesOnDateComponents.first else {
                XCTFail("Cannot get the recent next occurrence date")
                return
        }
        
        XCTAssertEqual(defaultRecentNextOccurrenceDate, decodedRecentNextOccurrenceDate)
    }
    
    func testEveryWeekdaysChargeScheduleRetrieve() {
        let expectation = self.expectation(description: "Schedule result")
        
        let scheduleTestingID: DataID<Schedule<Charge>>  = "schd_test_5fzoznrnfbwhyxx2slg"
        let request = Schedule<Charge>.retrieve(using: testClient, id: scheduleTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(schedule):
                let gregorianCalendar = Calendar(identifier: .gregorian)
                
                XCTAssertEqual(schedule.id, scheduleTestingID)
                XCTAssertEqual(schedule.location, "/schedules/schd_test_5fzoznrnfbwhyxx2slg")
                XCTAssertEqual(schedule.createdDate, dateFormatter.date(from: "2019-05-23T03:47:11Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.running)
                XCTAssertEqual(schedule.period, Period.weekly([.monday, .tuesday, .wednesday, .thursday, .friday]))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startOnDateComponents,
                               DateComponents(calendar: gregorianCalendar, year: 2019, month: 5, day: 23))
                XCTAssertEqual(schedule.endOnDateComponents,
                               DateComponents(calendar: gregorianCalendar, year: 2020, month: 5, day: 23))
                
                XCTAssertEqual(schedule.scheduleData.value.amount, 1000_00)
                XCTAssertEqual(schedule.scheduleData.value.currency, Currency.thb)
                XCTAssertEqual(schedule.scheduleData.customerID, "cust_test_5fz0olfpy32zadv96ek")
                
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeEveryWeekdaysChargeScheduleRetrieve() throws {
        let defaultSchedule = try fixturesObjectFor(type: Schedule<Charge>.self,
                                                    dataID: "schd_test_5fzoznrnfbwhyxx2slg")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultSchedule)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedSchedule = try decoder.decode(Schedule<Charge>.self, from: encodedData)
        XCTAssertEqual(defaultSchedule.object, decodedSchedule.object)
        XCTAssertEqual(defaultSchedule.id, decodedSchedule.id)
        XCTAssertEqual(defaultSchedule.isLiveMode, decodedSchedule.isLiveMode)
        XCTAssertEqual(defaultSchedule.location, decodedSchedule.location)
        XCTAssertEqual(defaultSchedule.status, decodedSchedule.status)
        XCTAssertEqual(defaultSchedule.every, decodedSchedule.every)
        XCTAssertEqual(defaultSchedule.period, decodedSchedule.period)
        XCTAssertEqual(defaultSchedule.startOnDateComponents, decodedSchedule.startOnDateComponents)
        XCTAssertEqual(defaultSchedule.endOnDateComponents, decodedSchedule.endOnDateComponents)
        
        XCTAssertEqual(defaultSchedule.scheduleData.value.amount, decodedSchedule.scheduleData.value.amount)
        XCTAssertEqual(defaultSchedule.scheduleData.value.currency, decodedSchedule.scheduleData.value.currency)
        XCTAssertEqual(defaultSchedule.scheduleData.customerID, decodedSchedule.scheduleData.customerID)
        XCTAssertEqual(defaultSchedule.createdDate, decodedSchedule.createdDate)
        
        XCTAssertEqual(defaultSchedule.occurrences.object, decodedSchedule.occurrences.object)
        XCTAssertEqual(defaultSchedule.occurrences.from, decodedSchedule.occurrences.from)
        XCTAssertEqual(defaultSchedule.occurrences.to, decodedSchedule.occurrences.to)
        XCTAssertEqual(defaultSchedule.occurrences.data.count, decodedSchedule.occurrences.data.count)
        
        XCTAssertEqual(defaultSchedule.nextOccurrencesOnDateComponents.count,
                       decodedSchedule.nextOccurrencesOnDateComponents.count)
        guard let defaultRecentNextOccurrenceDate = defaultSchedule.nextOccurrencesOnDateComponents.first,
            let decodedRecentNextOccurrenceDate = decodedSchedule.nextOccurrencesOnDateComponents.first else {
                XCTFail("Cannot get the recent next occurrence date")
                return
        }
        
        XCTAssertEqual(defaultRecentNextOccurrenceDate, decodedRecentNextOccurrenceDate)
    }
    
    func testDeletedChargeScheduleRetrieve() {
        let expectation = self.expectation(description: "Schedule result")
        
        let scheduleTestingID: DataID<Schedule<Charge>>  = "schd_test_5fzcqxg53hhuhz49e73"
        let request = Schedule<Charge>.retrieve(using: testClient, id: scheduleTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(schedule):
                let gregorianCalendar = Calendar(identifier: .gregorian)
                
                XCTAssertEqual(schedule.id, scheduleTestingID)
                XCTAssertEqual(schedule.location, "/schedules/schd_test_5fzcqxg53hhuhz49e73")
                XCTAssertEqual(schedule.createdDate, dateFormatter.date(from: "2019-05-22T06:55:11Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.deleted)
                XCTAssertEqual(schedule.period, Period.monthly(Period.MonthlyPeriodRule.daysOfMonth([25])))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startOnDateComponents,
                               DateComponents(calendar: gregorianCalendar, year: 2019, month: 5, day: 22))
                XCTAssertEqual(schedule.endOnDateComponents,
                               DateComponents(calendar: gregorianCalendar, year: 2020, month: 5, day: 22))
                
                XCTAssertEqual(schedule.scheduleData.value.amount, 10_000_00)
                XCTAssertEqual(schedule.scheduleData.value.currency, Currency.thb)
                XCTAssertEqual(schedule.scheduleData.customerID, "cust_test_5fz0olfpy32zadv96ek")
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeDeletedChargeScheduleRetrieve() throws {
        let defaultSchedule = try fixturesObjectFor(type: Schedule<Charge>.self,
                                                    dataID: "schd_test_5fzcqxg53hhuhz49e73")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultSchedule)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedSchedule = try decoder.decode(Schedule<Charge>.self, from: encodedData)
        XCTAssertEqual(defaultSchedule.object, decodedSchedule.object)
        XCTAssertEqual(defaultSchedule.id, decodedSchedule.id)
        XCTAssertEqual(defaultSchedule.isLiveMode, decodedSchedule.isLiveMode)
        XCTAssertEqual(defaultSchedule.location, decodedSchedule.location)
        XCTAssertEqual(defaultSchedule.status, decodedSchedule.status)
        XCTAssertEqual(defaultSchedule.every, decodedSchedule.every)
        XCTAssertEqual(defaultSchedule.period, decodedSchedule.period)
        XCTAssertEqual(defaultSchedule.startOnDateComponents, decodedSchedule.startOnDateComponents)
        XCTAssertEqual(defaultSchedule.endOnDateComponents, decodedSchedule.endOnDateComponents)
        
        XCTAssertEqual(defaultSchedule.scheduleData.value.amount, decodedSchedule.scheduleData.value.amount)
        XCTAssertEqual(defaultSchedule.scheduleData.value.currency, decodedSchedule.scheduleData.value.currency)
        XCTAssertEqual(defaultSchedule.scheduleData.customerID, decodedSchedule.scheduleData.customerID)
        
        XCTAssertEqual(defaultSchedule.occurrences.object, decodedSchedule.occurrences.object)
        XCTAssertEqual(defaultSchedule.occurrences.from, decodedSchedule.occurrences.from)
        XCTAssertEqual(defaultSchedule.occurrences.to, decodedSchedule.occurrences.to)
        XCTAssertEqual(defaultSchedule.occurrences.data.count, decodedSchedule.occurrences.data.count)
        
        XCTAssertEqual(defaultSchedule.createdDate, decodedSchedule.createdDate)
    }
    
    func testListSchedule() {
        let expectation = self.expectation(description: "List Schedule result")
        
        let request = Schedule<AnySchedulable>.list(using: testClient) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(schedules):
                XCTAssertEqual(schedules.total, 9)
                XCTAssertEqual(schedules.data.count, 9)
                
                guard let schedule = schedules.data.first else {
                    XCTFail("Cannot parse schedule from the list API")
                    return
                }
                
                let gregorianCalendar = Calendar(identifier: .gregorian)
                XCTAssertEqual(schedule.id, "schd_test_5fzpgks1yf8me0wabse")
                XCTAssertEqual(schedule.location, "/schedules/schd_test_5fzpgks1yf8me0wabse")
                XCTAssertEqual(schedule.createdDate, dateFormatter.date(from: "2019-05-23T04:35:15Z"))
                XCTAssertEqual(schedule.status, Schedule<AnySchedulable>.Status.running)
                XCTAssertEqual(schedule.period, Period.monthly(Period.MonthlyPeriodRule.daysOfMonth([27])))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startOnDateComponents,
                               DateComponents(calendar: gregorianCalendar, year: 2019, month: 5, day: 23))
                XCTAssertEqual(schedule.endOnDateComponents,
                               DateComponents(calendar: gregorianCalendar, year: 2020, month: 5, day: 23))
                
                let scheduleData = schedule.scheduleData
                if let percentage = scheduleData.json["amount"] as? Int {
                    XCTAssertEqual(percentage, 1000000)
                } else {
                    XCTFail("Wrong Charge amount parsed")
                }
                XCTAssertEqual(scheduleData.json["customer"] as? String, "cust_test_5fz0olfpy32zadv96ek")
                
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    
    func testCreateChargeSchedule() {
        let expectation = self.expectation(description: "Create Schedule result")
        
        let parameter = ChargeSchedulingParameter(value: Value(amount: 1000000, currency: .thb),
                                                  customerID: "cust_test_5fz0olfpy32zadv96ek", cardID: nil,
                                                  description: nil)
        let params = ScheduleParams<Charge>(
            every: 1, period: .monthly(.daysOfMonth([1, 16])),
            endDate: DateComponents(calendar: Calendar.scheduleAPICalendar, year: 2020, month: 5, day: 23),
            startDate: nil, scheduleData: parameter)
        let request = Schedule<Charge>.create(using: testClient, params: params) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(schedule):
                XCTAssertEqual(schedule.id, "schd_test_584zfswqzu5m40sycxc")
                XCTAssertEqual(schedule.location, "/schedules/schd_test_584zfswqzu5m40sycxc")
                XCTAssertEqual(schedule.createdDate, dateFormatter.date(from: "2019-05-23T04:35:15Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.running)
                XCTAssertEqual(schedule.period, Period.monthly(.daysOfMonth([1, 16])))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startOnDateComponents,
                               DateComponents(calendar: Calendar.scheduleAPICalendar, year: 2019, month: 5, day: 23))
                XCTAssertEqual(schedule.endOnDateComponents,
                               DateComponents(calendar: Calendar.scheduleAPICalendar, year: 2020, month: 5, day: 23))
                
                XCTAssertEqual(schedule.scheduleData.value.amount, 1000000)
                XCTAssertEqual(schedule.scheduleData.value.currency, Currency.thb)
                XCTAssertEqual(schedule.scheduleData.customerID, "cust_test_5fz0olfpy32zadv96ek")
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}

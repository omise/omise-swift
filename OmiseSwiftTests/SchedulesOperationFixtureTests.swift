import XCTest
@testable import Omise


class SchedulesOperationFixtureTests: FixtureTestCase {
    func testScheduleRetrieve() {
        let expectation = self.expectation(description: "Schedule result")
        
        let scheduleTestingID = "schd_test_582oau15y3okc3bxy2b"
        
        let request = Schedule<Transfer>.retrieve(using: testClient, id: scheduleTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(schedule):
                let gregorianCalendar = Calendar(identifier: .gregorian)
                
                XCTAssertEqual(schedule.id, scheduleTestingID)
                XCTAssertEqual(schedule.location, "/schedules/schd_test_582oau15y3okc3bxy2b")
                XCTAssertEqual(schedule.createdDate, dateFormatter.date(from: "2017-05-24T10:54:52Z"))
                XCTAssertEqual(schedule.status, Schedule<Transfer>.Status.running)
                let expectedMonthlyRule = Period.MonthlyPeriodRule.daysOfMonth([27])
                XCTAssertEqual(schedule.period, Period.monthly(expectedMonthlyRule))
                XCTAssertEqual(schedule.startOnDateComponents, DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 24))
                XCTAssertEqual(schedule.endOnDateComponents, DateComponents(calendar: gregorianCalendar, year: 2018, month: 5, day: 24))
                
                XCTAssertEqual(schedule.scheduleData.amount, TransferSchedulingParameter.Amount.percentageOfBalance(100))
                XCTAssertEqual(schedule.scheduleData.recipientID, "recp_test_54oojsyzyqdswyjcmsp")
                
                let firstNextOccurrenceDate = gregorianCalendar.date(from: DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 27))!
                let nextOccurrences = (0..<12).map({ (month) in
                    return gregorianCalendar.date(byAdding: .month, value: month, to: firstNextOccurrenceDate).flatMap({ gregorianCalendar.dateComponents([.calendar, .year, .month, .day], from: $0) })!
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
        let defaultSchedule = try fixturesObjectFor(type: Schedule<Transfer>.self, dataID: "schd_test_582oau15y3okc3bxy2b")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultSchedule)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedSchedule = try decoder.decode(Schedule<Transfer>.self, from: encodedData)
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
        XCTAssertEqual(decodedSchedule.scheduleData.recipientID, decodedSchedule.scheduleData.recipientID)
        XCTAssertEqual(defaultSchedule.createdDate, decodedSchedule.createdDate)
        
        guard let defaultRecentNextOccurrenceDate = defaultSchedule.nextOccurrencesOnDateComponents.first, let decodedRecentNextOccurrenceDate = decodedSchedule.nextOccurrencesOnDateComponents.first else {
            XCTFail("Cannot get the recent next occurrence date")
            return
        }
        XCTAssertEqual(defaultRecentNextOccurrenceDate, decodedRecentNextOccurrenceDate)
        XCTAssertEqual(defaultSchedule.nextOccurrencesOnDateComponents.count, decodedSchedule.nextOccurrencesOnDateComponents.count)
    }
    
    func testEveryDayChargeScheduleRetrieve() {
        let expectation = self.expectation(description: "Schedule result")
        
        let scheduleTestingID = "schd_test_582o6x3rigzamtpkhpu"
        let request = Schedule<Charge>.retrieve(using: testClient, id: scheduleTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(schedule):
                let gregorianCalendar = Calendar(identifier: .gregorian)
                
                XCTAssertEqual(schedule.id, scheduleTestingID)
                XCTAssertEqual(schedule.location, "/schedules/schd_test_582o6x3rigzamtpkhpu")
                XCTAssertEqual(schedule.createdDate, dateFormatter.date(from: "2017-05-24T10:43:45Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.running)
                XCTAssertEqual(schedule.period, Period.daily)
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startOnDateComponents, DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 24))
                XCTAssertEqual(schedule.endOnDateComponents, DateComponents(calendar: gregorianCalendar, year: 2018, month: 5, day: 24))
                
                XCTAssertEqual(schedule.scheduleData.value.amount, 31_900_00)
                XCTAssertEqual(schedule.scheduleData.value.currency, Currency.thb)
                XCTAssertEqual(schedule.scheduleData.customerID, "cust_test_582o6hikunmz90lx0wl")
                
                let firstNextOccurrenceDate = gregorianCalendar.date(from: DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 26))!
                let nextOccurrences = (0..<30).map({ (day) in
                    return gregorianCalendar.date(byAdding: .day, value: day, to: firstNextOccurrenceDate).flatMap({ gregorianCalendar.dateComponents([.calendar, .year, .month, .day], from: $0) })!
                })
                
                XCTAssertEqual(schedule.nextOccurrencesOnDateComponents, nextOccurrences)
                
                let occurrences = schedule.occurrences
                XCTAssertEqual(occurrences.total, 2)
                if let firstOccurrence = occurrences.data.first {
                    XCTAssertEqual(firstOccurrence.id, "occu_test_582o6x3smr1taeb7mdg")
                    XCTAssertEqual(firstOccurrence.schedule.dataID, scheduleTestingID)
                    XCTAssertEqual(firstOccurrence.scheduledOnDateComponents, DateComponents(calendar: gregorianCalendar, year: 2017, month: 5, day: 24))
                    XCTAssertEqual(firstOccurrence.status, .successful)
                    XCTAssertEqual(firstOccurrence.processedDate, dateFormatter.date(from: "2017-05-25T01:30:07Z"))
                    XCTAssertEqual(firstOccurrence.result.dataID, "chrg_test_582wuxps5hp238fh2lb")
                    XCTAssertEqual(firstOccurrence.createdDate, dateFormatter.date(from: "2017-05-24T10:43:45Z"))
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
        let defaultSchedule = try fixturesObjectFor(type: Schedule<Charge>.self, dataID: "schd_test_582o6x3rigzamtpkhpu")
        
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
        
        guard let defaultRecentNextOccurrenceDate = defaultSchedule.nextOccurrencesOnDateComponents.first, let decodedRecentNextOccurrenceDate = decodedSchedule.nextOccurrencesOnDateComponents.first else {
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
        
        guard let defaultRecentOccurrenceDate = defaultSchedule.occurrences.data.first, let decodedRecentOccurrenceDate = decodedSchedule.occurrences.data.first else {
            XCTFail("Cannot get the recent occurrence date")
            return
        }
        
        XCTAssertEqual(defaultRecentOccurrenceDate.object, decodedRecentOccurrenceDate.object)
        XCTAssertEqual(defaultRecentOccurrenceDate.isLiveMode, decodedRecentOccurrenceDate.isLiveMode)
        XCTAssertEqual(defaultRecentOccurrenceDate.id, decodedRecentOccurrenceDate.id)
        XCTAssertEqual(defaultRecentOccurrenceDate.location, decodedRecentOccurrenceDate.location)
        XCTAssertEqual(defaultRecentOccurrenceDate.schedule.dataID, decodedRecentOccurrenceDate.schedule.dataID)
        XCTAssertEqual(defaultRecentOccurrenceDate.processedDate, decodedRecentOccurrenceDate.processedDate)
        XCTAssertEqual(defaultRecentOccurrenceDate.status, decodedRecentOccurrenceDate.status)
        XCTAssertEqual(defaultRecentOccurrenceDate.result.dataID, decodedRecentOccurrenceDate.result.dataID)
        XCTAssertEqual(defaultRecentOccurrenceDate.createdDate, decodedRecentOccurrenceDate.createdDate)
    }
    
    func testEveryLastFridayOfMonthChargeScheduleRetrieve() {
        let expectation = self.expectation(description: "Schedule result")
        
        let scheduleTestingID = "schd_test_5830728kmmgobeli6ma"
        let request = Schedule<Charge>.retrieve(using: testClient, id: scheduleTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(schedule):
                let gregorianCalendar = Calendar(identifier: .gregorian)
                
                XCTAssertEqual(schedule.id, scheduleTestingID)
                XCTAssertEqual(schedule.location, "/schedules/schd_test_5830728kmmgobeli6ma")
                XCTAssertEqual(schedule.createdDate, dateFormatter.date(from: "2017-05-25T07:11:21Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.running)
                XCTAssertEqual(schedule.period, Period.monthly(Period.MonthlyPeriodRule.weekdayOfMonth(ordinal: .last, weekday: .friday)))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startOnDateComponents, DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 25))
                XCTAssertEqual(schedule.endOnDateComponents, DateComponents(calendar: gregorianCalendar, year: 2018, month: 5, day: 25))
                
                XCTAssertEqual(schedule.scheduleData.value.amount, 8990000)
                XCTAssertEqual(schedule.scheduleData.value.currency, Currency.thb)
                XCTAssertEqual(schedule.scheduleData.customerID, "cust_test_582o6hikunmz90lx0wl")
                
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeEveryLastFridayOfMonthChargeScheduleRetrieve() throws {
        let defaultSchedule = try fixturesObjectFor(type: Schedule<Charge>.self, dataID: "schd_test_5830728kmmgobeli6ma")
        
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
        
        XCTAssertEqual(defaultSchedule.nextOccurrencesOnDateComponents.count, decodedSchedule.nextOccurrencesOnDateComponents.count)
        guard let defaultRecentNextOccurrenceDate = defaultSchedule.nextOccurrencesOnDateComponents.first, let decodedRecentNextOccurrenceDate = decodedSchedule.nextOccurrencesOnDateComponents.first else {
            XCTFail("Cannot get the recent next occurrence date")
            return
        }
        
        XCTAssertEqual(defaultRecentNextOccurrenceDate, decodedRecentNextOccurrenceDate)
    }
    
    func testEveryFirstMondayOfMonthChargeScheduleRetrieve() {
        let expectation = self.expectation(description: "Schedule result")
        
        let scheduleTestingID = "schd_test_5830784ijsp6ybzh161"
        let request = Schedule<Charge>.retrieve(using: testClient, id: scheduleTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(schedule):
                let gregorianCalendar = Calendar(identifier: .gregorian)
                
                XCTAssertEqual(schedule.id, scheduleTestingID)
                XCTAssertEqual(schedule.location, "/schedules/schd_test_5830784ijsp6ybzh161")
                XCTAssertEqual(schedule.createdDate, dateFormatter.date(from: "2017-05-25T07:11:49Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.running)
                XCTAssertEqual(schedule.period, Period.monthly(Period.MonthlyPeriodRule.weekdayOfMonth(ordinal: .first, weekday: .monday)))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startOnDateComponents, DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 25))
                XCTAssertEqual(schedule.endOnDateComponents, DateComponents(calendar: gregorianCalendar, year: 2018, month: 5, day: 25))
                
                XCTAssertEqual(schedule.scheduleData.value.amount, 7490000)
                XCTAssertEqual(schedule.scheduleData.value.currency, Currency.thb)
                XCTAssertEqual(schedule.scheduleData.customerID, "cust_test_582o6hikunmz90lx0wl")
                
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeEveryFirstMondayOfMonthChargeScheduleRetrieve() throws {
        let defaultSchedule = try fixturesObjectFor(type: Schedule<Charge>.self, dataID: "schd_test_5830784ijsp6ybzh161")
        
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
        
        XCTAssertEqual(defaultSchedule.nextOccurrencesOnDateComponents.count, decodedSchedule.nextOccurrencesOnDateComponents.count)
        guard let defaultRecentNextOccurrenceDate = defaultSchedule.nextOccurrencesOnDateComponents.first, let decodedRecentNextOccurrenceDate = decodedSchedule.nextOccurrencesOnDateComponents.first else {
            XCTFail("Cannot get the recent next occurrence date")
            return
        }
        
        XCTAssertEqual(defaultRecentNextOccurrenceDate, decodedRecentNextOccurrenceDate)
    }
    
    func testEveryWeekdaysChargeScheduleRetrieve() {
        let expectation = self.expectation(description: "Schedule result")
        
        let scheduleTestingID = "schd_test_58306nhkn5goe12i4sx"
        let request = Schedule<Charge>.retrieve(using: testClient, id: scheduleTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(schedule):
                let gregorianCalendar = Calendar(identifier: .gregorian)
                
                XCTAssertEqual(schedule.id, scheduleTestingID)
                XCTAssertEqual(schedule.location, "/schedules/schd_test_58306nhkn5goe12i4sx")
                XCTAssertEqual(schedule.createdDate, dateFormatter.date(from: "2017-05-25T07:10:12Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.running)
                XCTAssertEqual(schedule.period, Period.weekly([.monday, .tuesday, .wednesday, .thursday, .friday]))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startOnDateComponents, DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 25))
                XCTAssertEqual(schedule.endOnDateComponents, DateComponents(calendar: gregorianCalendar, year: 2018, month: 5, day: 25))
                
                XCTAssertEqual(schedule.scheduleData.value.amount, 3190000)
                XCTAssertEqual(schedule.scheduleData.value.currency, Currency.thb)
                XCTAssertEqual(schedule.scheduleData.customerID, "cust_test_582o6hikunmz90lx0wl")
                
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeEveryWeekdaysChargeScheduleRetrieve() throws {
        let defaultSchedule = try fixturesObjectFor(type: Schedule<Charge>.self, dataID: "schd_test_58306nhkn5goe12i4sx")
        
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
        
        XCTAssertEqual(defaultSchedule.nextOccurrencesOnDateComponents.count, decodedSchedule.nextOccurrencesOnDateComponents.count)
        guard let defaultRecentNextOccurrenceDate = defaultSchedule.nextOccurrencesOnDateComponents.first, let decodedRecentNextOccurrenceDate = decodedSchedule.nextOccurrencesOnDateComponents.first else {
            XCTFail("Cannot get the recent next occurrence date")
            return
        }
        
        XCTAssertEqual(defaultRecentNextOccurrenceDate, decodedRecentNextOccurrenceDate)
    }
    
    func testDeletedChargeScheduleRetrieve() {
        let expectation = self.expectation(description: "Schedule result")
        
        let scheduleTestingID = "schd_test_58306a2njevec7qiqfz"
        let request = Schedule<Charge>.retrieve(using: testClient, id: scheduleTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(schedule):
                let gregorianCalendar = Calendar(identifier: .gregorian)
                
                XCTAssertEqual(schedule.id, scheduleTestingID)
                XCTAssertEqual(schedule.location, "/schedules/schd_test_58306a2njevec7qiqfz")
                XCTAssertEqual(schedule.createdDate, dateFormatter.date(from: "2017-05-25T07:09:08Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.deleted)
                XCTAssertEqual(schedule.period, Period.weekly([.tuesday, .wednesday, .thursday, .friday, .saturday]))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startOnDateComponents, DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 25))
                XCTAssertEqual(schedule.endOnDateComponents, DateComponents(calendar: gregorianCalendar, year: 2018, month: 5, day: 25))
                
                XCTAssertEqual(schedule.scheduleData.value.amount, 3190000)
                XCTAssertEqual(schedule.scheduleData.value.currency, Currency.thb)
                XCTAssertEqual(schedule.scheduleData.customerID, "cust_test_582o6hikunmz90lx0wl")
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeDeletedChargeScheduleRetrieve() throws {
        let defaultSchedule = try fixturesObjectFor(type: Schedule<Charge>.self, dataID: "schd_test_58306a2njevec7qiqfz")
        
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
                XCTAssertEqual(schedules.total, 8)
                XCTAssertEqual(schedules.data.count, 8)
                
                guard let schedule = schedules.data.first else {
                    XCTFail("Cannot parse schedule from the list API")
                    return
                }
                
                let gregorianCalendar = Calendar(identifier: .gregorian)
                XCTAssertEqual(schedule.id, "schd_test_582o4mb9rnji2q1pdty")
                XCTAssertEqual(schedule.location, "/schedules/schd_test_582o4mb9rnji2q1pdty")
                XCTAssertEqual(schedule.createdDate, dateFormatter.date(from: "2017-05-24T10:37:13Z"))
                XCTAssertEqual(schedule.status, Schedule<AnySchedulable>.Status.deleted)
                XCTAssertEqual(schedule.period, Period.monthly(Period.MonthlyPeriodRule.daysOfMonth([1, 27])))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startOnDateComponents, DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 24))
                XCTAssertEqual(schedule.endOnDateComponents, DateComponents(calendar: gregorianCalendar, year: 2018, month: 5, day: 24))
                
                let scheduleData = schedule.scheduleData
                if let percentage = scheduleData.json["percentage_of_balance"] as? Double {
                    XCTAssertEqual(percentage, 50)
                } else {
                    XCTFail("Wrong Transfer amount parsed")
                }
                XCTAssertEqual(scheduleData.json["recipient"] as? String, "recp_test_54oojsyzyqdswyjcmsp")
                
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
 
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    
    func testCreateChargeSchedule() {
        let expectation = self.expectation(description: "Create Schedule result")
        
        let parameter = ChargeSchedulingParameter(value: Value(amount: 36_900_00, currency: .thb), customerID: "cust_test_582o6hikunmz90lx0wl", cardID: nil, description: nil)
        let params = ScheduleParams<Charge>(every: 1, period: .monthly(.daysOfMonth([1, 16])), endDate: DateComponents(calendar: Calendar.scheduleAPICalendar, year: 2018, month: 5, day: 29), startDate: nil, scheduleData: parameter)
        let request = Schedule<Charge>.create(using: testClient, params: params) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(schedule):
                let gregorianCalendar = Calendar(identifier: .gregorian)
                
                XCTAssertEqual(schedule.id, "schd_test_584zfswqzu5m40sycxc")
                XCTAssertEqual(schedule.location, "/schedules/schd_test_584zfswqzu5m40sycxc")
                XCTAssertEqual(schedule.createdDate, dateFormatter.date(from: "2017-05-30T08:37:10Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.running)
                XCTAssertEqual(schedule.period, Period.monthly(.daysOfMonth([1, 16])))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startOnDateComponents, DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 30))
                XCTAssertEqual(schedule.endOnDateComponents, DateComponents(calendar: gregorianCalendar, year: 2018, month: 5, day: 20))
                
                XCTAssertEqual(schedule.scheduleData.value.amount, 36_900_00)
                XCTAssertEqual(schedule.scheduleData.value.currency, Currency.thb)
                XCTAssertEqual(schedule.scheduleData.customerID, "cust_test_582o6hikunmz90lx0wl")
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}


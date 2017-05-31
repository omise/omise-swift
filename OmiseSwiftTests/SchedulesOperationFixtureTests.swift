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
                XCTAssertEqual(schedule.createdDate, DateConverter.convert(fromAttribute: "2017-05-24T10:54:52Z"))
                XCTAssertEqual(schedule.status, Schedule<Transfer>.Status.active)
                let expectedMonthlyRule = Period.MonthlyPeriodRule.daysOfMonth([27])
                XCTAssertEqual(schedule.period, Period.monthly(expectedMonthlyRule))
                XCTAssertEqual(schedule.startDate, DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 24))
                XCTAssertEqual(schedule.endDate, DateComponents(calendar: gregorianCalendar, year: 2018, month: 5, day: 24))
                
                XCTAssertEqual(schedule.parameter.amount, TransferSchedulingParameter.Amount.percentageOfBalance(100))
                XCTAssertEqual(schedule.parameter.recipientID, "recp_test_54oojsyzyqdswyjcmsp")
                
                let firstNextOccurrenceDate = gregorianCalendar.date(from: DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 27))!
                let nextOccurrences = (0..<12).map({ (month) in
                    return gregorianCalendar.date(byAdding: .month, value: month, to: firstNextOccurrenceDate).flatMap({ gregorianCalendar.dateComponents([.calendar, .year, .month, .day], from: $0) })!
                })
                
                XCTAssertEqual(schedule.nextOccurrenceDates, nextOccurrences)
                
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
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
                XCTAssertEqual(schedule.createdDate, DateConverter.convert(fromAttribute: "2017-05-24T10:43:45Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.active)
                XCTAssertEqual(schedule.period, Period.daily)
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startDate, DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 24))
                XCTAssertEqual(schedule.endDate, DateComponents(calendar: gregorianCalendar, year: 2018, month: 5, day: 24))
                
                XCTAssertEqual(schedule.parameter.value.amount, 31_900_00)
                XCTAssertEqual(schedule.parameter.value.currency, Currency.thb)
                XCTAssertEqual(schedule.parameter.customerID, "cust_test_582o6hikunmz90lx0wl")
                
                let firstNextOccurrenceDate = gregorianCalendar.date(from: DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 26))!
                let nextOccurrences = (0..<30).map({ (day) in
                    return gregorianCalendar.date(byAdding: .day, value: day, to: firstNextOccurrenceDate).flatMap({ gregorianCalendar.dateComponents([.calendar, .year, .month, .day], from: $0) })!
                })
                
                XCTAssertEqual(schedule.nextOccurrenceDates, nextOccurrences)
                
                let occurrences = schedule.occurrences
                XCTAssertEqual(occurrences.total, 2)
                if let firstOccurrence = occurrences.data.first {
                XCTAssertEqual(firstOccurrence.id, "occu_test_582o6x3smr1taeb7mdg")
                XCTAssertEqual(firstOccurrence.schedule.dataID, scheduleTestingID)
                XCTAssertEqual(firstOccurrence.scheduleDate, DateComponents(calendar: gregorianCalendar, year: 2017, month: 5, day: 24))
                XCTAssertEqual(firstOccurrence.status, .successful)
                XCTAssertEqual(firstOccurrence.processedDate, DateConverter.convert(fromAttribute: "2017-05-25T01:30:07Z"))
                XCTAssertEqual(firstOccurrence.result.dataID, "chrg_test_582wuxps5hp238fh2lb")
                XCTAssertEqual(firstOccurrence.createdDate, DateConverter.convert(fromAttribute: "2017-05-24T10:43:45Z"))
                } else {
                    XCTFail("Failed to parse occurrences")
                }
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
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
                XCTAssertEqual(schedule.createdDate, DateConverter.convert(fromAttribute: "2017-05-25T07:11:21Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.active)
                XCTAssertEqual(schedule.period, Period.monthly(Period.MonthlyPeriodRule.weekdayOfMonth(ordinal: .last, weekday: .friday)))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startDate, DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 25))
                XCTAssertEqual(schedule.endDate, DateComponents(calendar: gregorianCalendar, year: 2018, month: 5, day: 25))
                
                XCTAssertEqual(schedule.parameter.value.amount, 8990000)
                XCTAssertEqual(schedule.parameter.value.currency, Currency.thb)
                XCTAssertEqual(schedule.parameter.customerID, "cust_test_582o6hikunmz90lx0wl")
                
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
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
                XCTAssertEqual(schedule.createdDate, DateConverter.convert(fromAttribute: "2017-05-25T07:11:49Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.active)
                XCTAssertEqual(schedule.period, Period.monthly(Period.MonthlyPeriodRule.weekdayOfMonth(ordinal: .first, weekday: .monday)))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startDate, DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 25))
                XCTAssertEqual(schedule.endDate, DateComponents(calendar: gregorianCalendar, year: 2018, month: 5, day: 25))
                
                XCTAssertEqual(schedule.parameter.value.amount, 7490000)
                XCTAssertEqual(schedule.parameter.value.currency, Currency.thb)
                XCTAssertEqual(schedule.parameter.customerID, "cust_test_582o6hikunmz90lx0wl")
                
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
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
                XCTAssertEqual(schedule.createdDate, DateConverter.convert(fromAttribute: "2017-05-25T07:10:12Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.active)
                XCTAssertEqual(schedule.period, Period.weekly([.monday, .tuesday, .wednesday, .thursday, .friday]))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startDate, DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 25))
                XCTAssertEqual(schedule.endDate, DateComponents(calendar: gregorianCalendar, year: 2018, month: 5, day: 25))
                
                XCTAssertEqual(schedule.parameter.value.amount, 3190000)
                XCTAssertEqual(schedule.parameter.value.currency, Currency.thb)
                XCTAssertEqual(schedule.parameter.customerID, "cust_test_582o6hikunmz90lx0wl")
                
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
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
                XCTAssertEqual(schedule.createdDate, DateConverter.convert(fromAttribute: "2017-05-25T07:09:08Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.deleted)
                XCTAssertEqual(schedule.period, Period.weekly([.tuesday, .wednesday, .thursday, .friday, .saturday]))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startDate, DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 25))
                XCTAssertEqual(schedule.endDate, DateComponents(calendar: gregorianCalendar, year: 2018, month: 5, day: 25))
                
                XCTAssertEqual(schedule.parameter.value.amount, 3190000)
                XCTAssertEqual(schedule.parameter.value.currency, Currency.thb)
                XCTAssertEqual(schedule.parameter.customerID, "cust_test_582o6hikunmz90lx0wl")
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
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
                XCTAssertEqual(schedule.createdDate, DateConverter.convert(fromAttribute: "2017-05-24T10:37:13Z"))
                XCTAssertEqual(schedule.status, Schedule<AnySchedulable>.Status.deleted)
                XCTAssertEqual(schedule.period, Period.monthly(Period.MonthlyPeriodRule.daysOfMonth([1, 27])))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startDate, DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 24))
                XCTAssertEqual(schedule.endDate, DateComponents(calendar: gregorianCalendar, year: 2018, month: 5, day: 24))
                
                guard case .transfer(let parameter) = schedule.parameter else {
                    XCTFail("Cannot parse schedule parameter")
                    return
                }
                
                if case .percentageOfBalance(let percentage) = parameter.amount {
                    XCTAssertEqual(percentage, 50)
                } else {
                    XCTFail("Wrong Transfer amount parsed")
                }
                XCTAssertEqual(parameter.recipientID, "recp_test_54oojsyzyqdswyjcmsp")
                
            case let .fail(error):
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
                XCTAssertEqual(schedule.createdDate, DateConverter.convert(fromAttribute: "2017-05-30T08:37:10Z"))
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.active)
                XCTAssertEqual(schedule.period, Period.monthly(.daysOfMonth([1, 16])))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.startDate, DateComponents(calendar: gregorianCalendar,year: 2017, month: 5, day: 30))
                XCTAssertEqual(schedule.endDate, DateComponents(calendar: gregorianCalendar, year: 2018, month: 5, day: 20))
                
                XCTAssertEqual(schedule.parameter.value.amount, 36_900_00)
                XCTAssertEqual(schedule.parameter.value.currency, Currency.thb)
                XCTAssertEqual(schedule.parameter.customerID, "cust_test_582o6hikunmz90lx0wl")
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}


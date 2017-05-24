import XCTest
@testable import Omise


private let scheduleTestingID = "schd_test_582oau15y3okc3bxy2b"

class SchedulesOperationFixtureTests: FixtureTestCase {
    func testScheduleRetrieve() {
        let expectation = self.expectation(description: "Schedule result")
        
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
}


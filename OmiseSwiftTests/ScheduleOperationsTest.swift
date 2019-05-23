import Foundation
import XCTest
@testable import Omise


class ScheduleOperationsTest: LiveTest {
    
    func testCreateEveryMonthChargeSchedule() {
        let expectation = self.expectation(description: "Create Schedule result")
        
        let parameter = ChargeSchedulingParameter(value: Value(amount: 36_900_00, currency: .thb), customerID: "cust_test_582o6hikunmz90lx0wl", cardID: nil, description: nil)
        let params = ScheduleParams<Charge>(every: 1, period: Period.monthly(Period.MonthlyPeriodRule.daysOfMonth([1])), endDate: DateComponents(calendar: Calendar.scheduleAPICalendar, year: 2018, month: 5, day: 29), startDate: nil, scheduleData: parameter)
        let request = Schedule<Charge>.create(using: testClient, params: params) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(schedule):
                let gregorianCalendar = Calendar(identifier: .gregorian)
                
                XCTAssertEqual(schedule.status, Schedule<Charge>.Status.active)
                XCTAssertEqual(schedule.period, Period.monthly(.daysOfMonth([1])))
                XCTAssertEqual(schedule.every, 1)
                XCTAssertEqual(schedule.endDate, DateComponents(calendar: gregorianCalendar, year: 2018, month: 5, day: 29))
                
                XCTAssertEqual(schedule.scheduleData.value.amount, 36_900_00)
                XCTAssertEqual(schedule.scheduleData.value.currency, Currency.thb)
                XCTAssertEqual(schedule.scheduleData.customerID, "cust_test_582o6hikunmz90lx0wl")
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}


//
//  SettingsServiceTests.swift
//  ViperNewsTests
//
//  Created by Тарас Минин on 07/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import XCTest
@testable import ViperNews

class SettingsServiceTests: XCTestCase {

    private class MockUserDefaults: UserDefaults {

        var changesCounter = 0

        override func set(_ value: Double, forKey defaultName: String) {
            if defaultName == "Settings.FeedUpdateTime" {
                changesCounter += 1
            }
            super.set(value, forKey: defaultName)
        }
    }

    private var mockDefaults: MockUserDefaults!

    var sut: SettingsServiceImpl!

    override func setUpWithError() throws {
        mockDefaults = MockUserDefaults(suiteName: "SettingsServiceTests")
        sut = SettingsServiceImpl(userDefaults: mockDefaults)
    }

    override func tearDownWithError() throws {
        mockDefaults.removeObject(forKey: "Settings.FeedUpdateTime")
        mockDefaults = nil
        sut = nil
    }

    func testTimerDefault() throws {
        XCTAssert(sut.feedUpdateTimer != 0, "Timer value should never be 0")
    }

    func testTimerRandomSet() throws {
        var timerValue: TimeInterval = 24
        sut.setUpdateTimer(time: timerValue)

        XCTAssert(sut.feedUpdateTimer != timerValue, "Can't set random value for timer")

        timerValue = -3
        sut.setUpdateTimer(time: timerValue)

        XCTAssert(sut.feedUpdateTimer != timerValue, "Can't set random value for timer")
    }

    func testTimerProperSet() throws {
        let newTimer = SettingsServiceImpl.NewsUpdateTimer.long
        sut.setUpdateTimer(time: newTimer.rawValue)

        XCTAssert(sut.feedUpdateTimer == newTimer.rawValue, "Timer should be set")
    }

    func testMultipleSet() throws {
        let newTimer = SettingsServiceImpl.NewsUpdateTimer.medium

        sut.setUpdateTimer(time: newTimer.rawValue)
        sut.setUpdateTimer(time: newTimer.rawValue)
        sut.setUpdateTimer(time: newTimer.rawValue)

        XCTAssertEqual(mockDefaults.changesCounter, 1, "Should not invoke setter if new value is the same as old value")
    }
}

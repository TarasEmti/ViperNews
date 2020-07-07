//
//  UpdateServiceTest.swift
//  ViperNewsTests
//
//  Created by Тарас Минин on 07/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import XCTest
@testable import ViperNews

class UpdateServiceTest: XCTestCase {

    private class MockUserDefaults: UserDefaults {

        var changesCounter = 0

        override func set(_ value: Bool, forKey defaultName: String) {
            if defaultName == "Update.DefaultSettings" {
                changesCounter += 1
            }
            super.set(value, forKey: defaultName)
        }
    }

    private var mockDefaults: MockUserDefaults!
    var sut: UpdateService!

    override func setUpWithError() throws {
        mockDefaults = MockUserDefaults(suiteName: "UpdateServiceTest")
        sut = UpdateService(userDefaults: mockDefaults)
    }

    override func tearDownWithError() throws {
        mockDefaults.set(false, forKey: "Update.DefaultSettings")
        mockDefaults = nil
        sut = nil
    }

    func testFirstCall() throws {
        XCTAssertEqual(mockDefaults.changesCounter, 0, "There should be no changes before checking updates")

        sut.checkUpdates()

        XCTAssertEqual(mockDefaults.changesCounter, 1, "Defaults should be implemented")
    }

    func testMultipleCalls() {

        sut.checkUpdates()
        sut.checkUpdates()

        XCTAssertEqual(mockDefaults.changesCounter, 1, "Defaults should be implemented only once")
    }
}

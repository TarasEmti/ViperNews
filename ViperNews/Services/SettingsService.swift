//
//  SettingsService.swift
//  ViperNews
//
//  Created by Тарас Минин on 03/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import Foundation

@objc protocol SettigsService: class {
    dynamic var feedUpdateTimer: TimeInterval { get }
    func setUpdateTimer(time: TimeInterval)
}

final class SettingsServiceImpl: NSObject, SettigsService {

    private enum UserKeys {
        static let feedUpdateTime = "Settings.FeedUpdateTime"
    }

    static func shared() -> SettigsService {
        return singleton
    }
    private static let singleton = SettingsServiceImpl()

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    private(set) var feedUpdateTimer: TimeInterval {
        get {
            let sec = userDefaults.double(forKey: UserKeys.feedUpdateTime)

            if sec.isZero {
                return NewsUpdateTimer.short.rawValue
            }

            return sec
        }
        set {
            willChangeValue(for: \.feedUpdateTimer)
            userDefaults.set(newValue, forKey: UserKeys.feedUpdateTime)
            didChangeValue(for: \.feedUpdateTimer)
        }
    }

    func setUpdateTimer(time: TimeInterval) {
        guard
            let _ = NewsUpdateTimer(rawValue: time),
            time != feedUpdateTimer else {
                
            return
        }
        feedUpdateTimer = time
    }
}

extension SettingsServiceImpl {

    enum NewsUpdateTimer: TimeInterval, CaseIterable {
        case extraShort = 5
        case short = 10
        case medium = 30
        case long = 60
    }
}

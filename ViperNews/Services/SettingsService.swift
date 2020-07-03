//
//  SettingsService.swift
//  ViperNews
//
//  Created by Тарас Минин on 03/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import Foundation

protocol SettigsService: class {
    var feedUpdateTime: Double { get set }
}

final class SettingsServiceImpl: SettigsService {

    private enum UserKeys {
        static let feedUpdateTime = "Settings.FeedUpdateTime"
    }

    static func shared() -> SettigsService {
        return SettingsServiceImpl()
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var feedUpdateTime: Double {
        get {
            return userDefaults.double(forKey: UserKeys.feedUpdateTime)
        }
        set {
            userDefaults.set(newValue, forKey: UserKeys.feedUpdateTime)
        }
    }
}

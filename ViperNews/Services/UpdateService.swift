//
//  UpdateService.swift
//  ViperNews
//
//  Created by Тарас Минин on 03/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import Foundation

final class UpdateService {

    private enum UserKeys {
        static let isDefaultSettingsInstalled = "Update.DefaultSettings"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    private var isDefaultsInstalled: Bool {
        get {
            return userDefaults.bool(forKey: UserKeys.isDefaultSettingsInstalled)
        }
        set {
            userDefaults.set(newValue, forKey: UserKeys.isDefaultSettingsInstalled)
        }
    }

    func checkUpdates() {
        setDefaultSettingsIfNeeded()
    }

    private func setDefaultSettingsIfNeeded() {
        defer { isDefaultsInstalled = true }

        let settings = SettingsServiceImpl.shared()

        if !isDefaultsInstalled {
            let defaultTimer: SettingsServiceImpl.FeedUpdateTimer = .short
            settings.setUpdateTimer(time: defaultTimer.rawValue)
        }
    }
}


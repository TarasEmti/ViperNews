//
//  BaseNewsSource.swift
//  ViperNews
//
//  Created by Тарас Минин on 04/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import Foundation

@objc protocol NewsSource {
    var name: String { get }
    var feedUrl: String { get }
    var isEnabled: Bool { get set }

    func toggleIsEnabled()
}

class BaseNewsSource: NSObject, NewsSource {

    private lazy var isDisabledKey = "NewsSource.\(String(describing: type(of: self))).isDisabledKey"

    private let userDefaults = UserDefaults.standard

    let feedUrl: String

    let name: String

    init(feedUrl: String, name: String) {
        self.feedUrl = feedUrl
        self.name = name
        super.init()
    }

    var isEnabled: Bool {
        get {
            return !userDefaults.bool(forKey: isDisabledKey)
        }
        set {
            userDefaults.set(!newValue, forKey: isDisabledKey)
        }
    }

    @objc func toggleIsEnabled() {
        isEnabled.toggle()
    }
}

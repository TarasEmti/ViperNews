//
//  NewsFeedSource.swift
//  ViperNews
//
//  Created by Тарас Минин on 02/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import Foundation

@objc protocol NewsSource {
    var name: String { get }
    var feedUrl: String { get }
    var isEnabled: Bool { get set }

    func toggleIsEnabled()
}

protocol NewsSourceLoading: NewsSource {
    var feedLoader: NewsLoading { get }
}

final class GazetaNewsSource: BaseFeedSource {

    init() {
        super.init(feedUrl: "https://www.gazeta.ru/export/rss/lenta.xml", name: "Gazeta Ru")
    }
}

final class LentaNewsSource: BaseFeedSource {

    init() {
        super.init(feedUrl: "https://lenta.ru/rss", name: "Lenta Ru")
    }
}

class BaseFeedSource: NSObject, NewsSourceLoading {

    private lazy var isDisabledKey = "NewsSource.\(String(describing: type(of: self))).isDisabledKey"

    private let userDefaults = UserDefaults.standard

    let feedUrl: String

    let name: String

    let feedLoader: NewsLoading

    init(feedUrl: String, name: String) {
        self.feedUrl = feedUrl
        self.name = name
        feedLoader = NewsLoader(urlString: feedUrl)
        super.init()
    }

    @objc var isEnabled: Bool {
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

//
//  NewsSourcesProvider.swift
//  ViperNews
//
//  Created by Тарас Минин on 04/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

protocol NewsFeedSourceProvidable {
    func allFeedSources() -> [NewsSource]
    func enabledFeedSources() -> [NewsSourceLoading]
}

final class NewsSourcesProvider: NewsFeedSourceProvidable {

    private let sources: [NewsSourceLoading] = [
        LentaNewsSource(),
        GazetaNewsSource()
    ]

    func allFeedSources() -> [NewsSource] {
        return sources
    }

    func enabledFeedSources() -> [NewsSourceLoading] {
        return sources.filter { $0.isEnabled }
    }
}

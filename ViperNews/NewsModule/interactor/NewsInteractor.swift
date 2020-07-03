//
//  NewsInteractor.swift
//  ViperNews
//
//  Created by Тарас Минин on 03/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import Foundation

final class LocalNewsSourcesProvider: NewsFeedSourceProvidable {

    private let sources: [NewsSource] = [
        NewsSource(name: "Lenta RU",
                   feedUrl: "http://lenta.ru/rss",
                   isEnabled: true),

        NewsSource(name: "Gazeta RU",
                   feedUrl: "http://www.gazeta.ru/export/rss/lenta.xml",
                   isEnabled: true)
    ]

    func allFeedSources() -> [NewsSource] {
        return sources
    }

    func enabledFeedSources() -> [NewsSource] {
        return sources.filter { $0.isEnabled }
    }
}

final class NewsInteractor {

    var presenter: InteractorToPresenterProtocol?

    private let sources: [NewsSource]

    init(source: NewsFeedSourceProvidable = LocalNewsSourcesProvider()) {
        self.sources = source.enabledFeedSources()
    }

    private func loadNews() {

        var unsortedNews = [NewsItem]()

        var failedSources = [NewsSource]()
        let queue = DispatchQueue(label: "com.load.news", qos: .background, attributes: .concurrent)
        let group = DispatchGroup()

        let loaders: [NewsLoader] = sources.map { NewsLoader(source: $0) }

        queue.async(group: group) {

            loaders.forEach { (loader) in
                group.enter()

                loader.loadFeed { (news, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        failedSources.append(loader.source)
                    } else if let news = news, !news.isEmpty {
                        unsortedNews.append(contentsOf: news)
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { fatalError("Ineractor deinited") }
            self.presenter?.newsFetchSuccess(unsortedNews: unsortedNews)
            if !failedSources.isEmpty {
                self.presenter?.newsFetchFail(sources: failedSources)
            }
        }
    }
}

extension NewsInteractor: PresenterToInteractorProtocol {

    func fetchNews() {
        loadNews()
    }
}

extension NewsInteractor {

    private final class NewsLoader {

        private let sourceUrl: URL

        let source: NewsSource

        init(source: NewsSource) {
            self.source = source
            sourceUrl = URL(string: source.feedUrl)!
        }

        func loadFeed(completion: @escaping ([NewsItem]?, Error?) -> Void) {
            // Api Request magic

            let item = NewsItem(image: nil,
                                title: "Lalaland is on danger",
                                details: "Lorem ipsum",
                                source: source.name,
                                date: Date())

            completion([item], nil)
        }
    }
}

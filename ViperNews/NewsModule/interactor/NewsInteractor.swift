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
        LentaNewsSource(),
        GazetaNewsSource()
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

    private let storeProvider: NewsItemsStoreProvider
    private let sources: [NewsSource]

    init(source: NewsFeedSourceProvidable = LocalNewsSourcesProvider()) {
        self.sources = source.enabledFeedSources()
        self.storeProvider = NewsItemsStore()
    }

    private func loadNews() {

        var unsortedNews = [NewsItem]()

        var failedSources = [NewsSource]()
        let queue = DispatchQueue(label: "com.load.news", qos: .background, attributes: .concurrent)
        let group = DispatchGroup()

        queue.async(group: group) { [weak self] in

            guard let self = self else { fatalError("NewsInteractor deinited") }

            self.sources.forEach { (source) in
                group.enter()

                source.feedLoader.loadFeed { (news, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        failedSources.append(source)
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
            self.saveToStore(news: unsortedNews)
            if !failedSources.isEmpty {
                self.presenter?.newsFetchFail(sources: failedSources)
            }
        }
    }

    private func saveToStore(news: [NewsItem]) {
        storeProvider.save(news: news)
    }
}

extension NewsInteractor: PresenterToInteractorProtocol {

    func fetchNews() {
        storeProvider.fetchNews(enabledSources: sources) { [weak self] (items) in
            guard let self = self else { return }
            if items.isEmpty {
                self.loadNews()
            } else {
                self.presenter?.newsFetchSuccess(unsortedNews: items)
            }
        }
    }
}

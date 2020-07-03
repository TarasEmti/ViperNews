//
//  NewsInteractor.swift
//  ViperNews
//
//  Created by Тарас Минин on 03/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import Foundation

final class NewsInteractor {

    var presenter: InteractorToPresenterProtocol?

    private let storeProvider: NewsItemsStoreProvider
    private let sourcesProvider: NewsFeedSourceProvidable
    private let settings = SettingsServiceImpl.shared()

    private var timer: Timer?

    init(source: NewsFeedSourceProvidable = NewsSourcesProvider()) {
        self.sourcesProvider = source
        self.storeProvider = NewsItemsStore()

        setTimer()
    }

    private func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: settings.feedUpdateTime,
                                         repeats: true) { [weak self] (_) in
            self?.loadNews()
        }
    }

    private func loadNews() {

        var unsortedNews = [NewsItem]()

        var failedSources = [NewsSource]()
        let queue = DispatchQueue(label: "com.load.news",
                                  qos: .background,
                                  attributes: .concurrent)
        let group = DispatchGroup()

        queue.async(group: group) { [weak self] in
            guard let self = self else { fatalError("NewsInteractor deinited") }

            self.sourcesProvider.enabledFeedSources().forEach { (source) in
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
            guard let self = self else { fatalError("NewsInteractor deinited") }

            self.saveToStore(news: unsortedNews)
            self.fetchNews()
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
        storeProvider.fetchNews(enabledSources: sourcesProvider.enabledFeedSources()) { [weak self] (items) in
            guard let self = self else { return }
            if items.isEmpty {
                self.loadNews()
            } else {
                self.presenter?.newsFetchSuccess(unsortedNews: items)
            }
        }
    }

    func update(newsItem: NewsItem) {
        storeProvider.save(news: [newsItem])
    }
}

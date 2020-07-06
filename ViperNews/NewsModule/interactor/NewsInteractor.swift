//
//  NewsInteractor.swift
//  ViperNews
//
//  Created by Тарас Минин on 03/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import Foundation

final class NewsInteractor: NSObject {

    var presenter: InteractorToPresenterProtocol?

    private let storeProvider: NewsItemsStoreProvider
    private let sourcesProvider: NewsFeedSourceProvidable
    @objc private let settings = SettingsServiceImpl.shared()

    private var timer: Timer?
    private var timerObservation: NSKeyValueObservation?

    init(source: NewsFeedSourceProvidable = NewsSourcesProvider()) {
        self.sourcesProvider = source
        self.storeProvider = NewsItemsStore()
        super.init()

        timerObservation = observe(\.settings.feedUpdateTimer, options: [.new]) { [weak self] (_, _) in
            self?.updateTimer()
        }

        setTimer()
    }

    private func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: settings.feedUpdateTimer,
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
            let loaders = self.sourcesProvider
                .enabledFeedSources()
                .map { NewsLoader(newsSource: $0) }

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

    func updateTimer() {
        timer?.invalidate()
        timer = nil
        setTimer()
    }
}

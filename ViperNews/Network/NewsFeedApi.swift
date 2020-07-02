//
//  NewsFeedApi.swift
//  ViperNews
//
//  Created by Тарас Минин on 02/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import Foundation

protocol NewsFeedSourceProvidable {
    func allFeedSources() -> [NewsFeedSourceProtocol]
    func enabledFeedSources() -> [NewsFeedSourceProtocol]
}

protocol PresenterToInteractorProtocol {}
protocol InteractorToPresenterProtocol {}

final class NewsInteractor {

    var presenter: InteractorToPresenterProtocol?

    private let sources: [NewsFeedSourceProtocol]

    private var unsortedNewsBag: [NewsItem] = []

    init(source: NewsFeedSourceProvidable) {
        self.sources = source.enabledFeedSources()
    }

    func retrieveNews(feedCompletion: @escaping ([NewsItem]) -> Void) {

        unsortedNewsBag = []

        let queue = DispatchQueue(label: "com.load.news", qos: .background, attributes: .concurrent)
        let group = DispatchGroup()

        let loaders: [NewsLoader] = sources.map { NewsLoader(source: $0) }

        loaders.forEach { (loader) in
            queue.async(group: group) {
                group.enter()

                loader.loadFeed { [unowned self] (news) in
                    self.unsortedNewsBag.append(contentsOf: news)
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) { [unowned self] in
            feedCompletion(self.unsortedNewsBag)
        }
    }
}

extension NewsInteractor {
    private final class NewsLoader {

        private let sourceUrl: URL

        init(source: NewsFeedSourceProtocol) {
            sourceUrl = URL(string: source.feedUrl)!
        }

        func loadFeed(completion: @escaping ([NewsItem]) -> Void) {
            // Api Request magic
            completion([])
        }
    }
}

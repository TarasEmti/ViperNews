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

final class NewsInteractor {

    var presenter: InteractorToPresenterProtocol?

    private let sources: [NewsFeedSourceProtocol]

    init(source: NewsFeedSourceProvidable) {
        self.sources = source.enabledFeedSources()
    }

    func retrieveNews() {

        var unsortedNews = [NewsItem]()

        var failedSources = [NewsFeedSourceProtocol]()
        let queue = DispatchQueue(label: "com.load.news", qos: .background, attributes: .concurrent)
        let group = DispatchGroup()

        let loaders: [NewsLoader] = sources.map { NewsLoader(source: $0) }

        loaders.forEach { (loader) in
            queue.async(group: group) {
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

        group.notify(queue: .main) { [unowned self] in
            self.presenter?.newsFetchSuccess(unsortedNews: unsortedNews)
            if !failedSources.isEmpty {
                self.presenter?.newsFetchFail(sources: failedSources)
            }
        }
    }
}

extension NewsInteractor {
    private final class NewsLoader {

        let source: NewsFeedSourceProtocol
        private let sourceUrl: URL

        init(source: NewsFeedSourceProtocol) {
            self.source = source
            sourceUrl = URL(string: source.feedUrl)!
        }

        func loadFeed(completion: @escaping ([NewsItem]?, Error?) -> Void) {
            // Api Request magic
            completion([], nil)
        }
    }
}

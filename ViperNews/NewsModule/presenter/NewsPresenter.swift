//
//  NewsPresenter.swift
//  ViperNews
//
//  Created by Тарас Минин on 03/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import Foundation

final class NewsPresenter {

    var view: PresenterToViewProtocol?

    var interactor: PresenterToInteractorProtocol?

    var router: NewsCoordinatorRouter?
}

extension NewsPresenter: InteractorToPresenterProtocol {

    func newsFetchSuccess(unsortedNews: [NewsItem]) {
        let sortedNews = unsortedNews.sorted(by: {$0.date < $1.date})
        view?.show(news: sortedNews)
    }

    func newsFetchFail(sources: [NewsSource]) {
        let title = "Fetch error"
        let message: String
        if sources.isEmpty {
            message = "Something went wrong"
        } else {
            let sourcesNames = sources.map { $0.name }
            let sourcesString = sourcesNames.joined(separator: "\n")
            message = "Can't find news in sources:\n\(sourcesString)"
        }
        view?.showError(title: title, message: message)
    }
}

extension NewsPresenter: ViewToPresenterProtocol {

    func fetchNews() {
        interactor?.fetchNews()
    }

    func showSettings() {
        router?.showSettings()
    }
}

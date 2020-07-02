//
//  InteractorToPresenterProtocol.swift
//  ViperNews
//
//  Created by Тарас Минин on 02/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

protocol InteractorToPresenterProtocol {
    func newsFetchSuccess(unsortedNews: [NewsItem])
    func newsFetchFail(sources: [NewsFeedSourceProtocol])
}

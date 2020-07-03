//
//  NewsFeedApi.swift
//  ViperNews
//
//  Created by Тарас Минин on 02/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import Foundation

protocol NewsFeedSourceProvidable {
    func allFeedSources() -> [NewsSource]
    func enabledFeedSources() -> [NewsSource]
}

protocol PresenterToInteractorProtocol {
    func fetchNews()
}

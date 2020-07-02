//
//  PresenterToViewProtocol.swift
//  ViperNews
//
//  Created by Тарас Минин on 02/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

protocol PresenterToViewProtocol {
    func show(news: [NewsItem])
    func showError(title: String?, message: String?)
}

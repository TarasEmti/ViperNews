//
//  ViewToPresenterProtocol.swift
//  ViperNews
//
//  Created by Тарас Минин on 02/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

protocol ViewToPresenterProtocol {

    var view: PresenterToViewProtocol? { get set }

    var interactor: PresenterToInteractorProtocol? { get set }

    var router: NewsCoordinatorRouter? { get set }

    func fetchNews()
    func showSettings()
}

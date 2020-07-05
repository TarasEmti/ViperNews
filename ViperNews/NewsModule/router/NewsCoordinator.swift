//
//  NewsCoordinator.swift
//  ViperNews
//
//  Created by Тарас Минин on 02/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import UIKit

final class NewsCoordinator: NavigationCoordinator {

    private weak var scene: UIScene!
    private weak var sceneDelegate: SceneDelegate!

    init(scene: UIScene, sceneDelegate: SceneDelegate) {
        self.scene = scene
        self.sceneDelegate = sceneDelegate

        let nc = UINavigationController()
        super.init(rootViewController: nc)
    }

    override func start(with completion: @escaping () -> Void = {}) {
        super.start(with: completion)

        assembleNewsModule()
    }

    private func assembleNewsModule() {
        let view = NewsViewController()
        let presenter = NewsPresenter()
        let interactor = NewsInteractor()

        view.presenter = presenter

        presenter.view = view
        presenter.router = self
        presenter.interactor = interactor

        interactor.presenter = presenter

        show(view)
    }
}

extension NewsCoordinator: NewsCoordinatorRouter {

    func showSettings() {
        let vc = SettingsViewController()
        vc.router = self
        show(vc)
    }

    func showUpdateTimerSettings() {
        let vc = UpdateTimeSettingsViewController()
        vc.router = self
        show(vc)
    }

    func pop() {
        pop(animated: true)
    }
}

protocol NewsCoordinatorRouter: class {
    func showSettings()
    func showUpdateTimerSettings()
    func pop()
}

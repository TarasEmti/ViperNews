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

        showContent()
    }

    private func showContent() {
        let vc = NewsViewController()
        show(vc)
    }
}

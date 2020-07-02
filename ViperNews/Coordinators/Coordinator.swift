//
//  Coordinator.swift
//  ViperNews
//
//  Created by Тарас Минин on 02/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import UIKit

class Coordinator<VC: UIViewController>: UIResponder, Coordinating {

    let rootViewController: VC

    init(rootViewController: VC) {
        self.rootViewController = rootViewController
        super.init()
    }

    lazy var identifier: String = {
        return String(describing: type(of: self))
    }()

    private(set) var isStarted = false

    func start(with completion: @escaping () -> Void = {}) {
        isStarted = true
        completion()
    }

    func stop(with completion: @escaping () -> Void = {}) {
        completion()
    }
}

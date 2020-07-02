//
//  NavigationCoordinator.swift
//  ViperNews
//
//  Created by Тарас Минин on 02/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import UIKit

class NavigationCoordinator: Coordinator<UINavigationController>, UINavigationControllerDelegate {
    var viewControllers: [UIViewController] = []

    func present(_ vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        rootViewController.present(vc, animated: animated, completion: completion)
    }

    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        rootViewController.dismiss(animated: animated, completion: completion)
    }

    func show(_ vc: UIViewController) {
        viewControllers.append(vc)
        rootViewController.show(vc, sender: self)
    }

    func pop(animated: Bool = true) {
        // There must be at least two VCs in order for UINC.pop to succeed
        if viewControllers.count < 2 {
            return
        }
        viewControllers = Array(viewControllers.dropLast())

        rootViewController.popViewController(animated: animated)
    }

    override func start(with completion: @escaping () -> Void) {
        rootViewController.delegate = self
        super.start(with: completion)
    }

    override func stop(with completion: @escaping () -> Void) {
        rootViewController.delegate = nil

        for index in 0 ..< viewControllers.count {
            rootViewController.viewControllers.remove(at: index)
        }
        viewControllers.removeAll()

        super.stop(with: completion)
    }
}


//
//  Coordinating.swift
//  ViperNews
//
//  Created by Тарас Минин on 02/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

protocol Coordinating: class {

    var identifier: String { get }

    func start(with completion: @escaping () -> Void)

    func stop(with completion: @escaping () -> Void)
}

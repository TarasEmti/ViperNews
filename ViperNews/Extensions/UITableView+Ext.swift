//
//  UITableView+Ext.swift
//  ViperNews
//
//  Created by Тарас Минин on 02/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import UIKit

extension UITableView {

    func registerCell<Cell: UITableViewCell>(with type: Cell.Type) {
        register(type, forCellReuseIdentifier: type.reuseIdentifier)
    }

    func dequeueReusableCell<Cell: UITableViewCell>(with type: Cell.Type) -> Cell {
        let cell = dequeueReusableCell(withIdentifier: type.reuseIdentifier) as! Cell

        return cell
    }
}

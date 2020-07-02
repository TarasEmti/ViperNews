//
//  UITableViewCell+Ext.swift
//  ViperNews
//
//  Created by Тарас Минин on 02/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import UIKit

extension UITableViewCell {

    class var reuseIdentifier: String {
        return String(describing: type(of: self))
    }
}

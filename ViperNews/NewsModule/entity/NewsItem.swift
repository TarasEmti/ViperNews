//
//  NewsItem.swift
//  ViperNews
//
//  Created by Тарас Минин on 02/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import UIKit

struct NewsItem {
    var image: UIImage?
    let imageUrl: URL?
    let title: String
    let details: String
    let source: String
    let date: Date
}

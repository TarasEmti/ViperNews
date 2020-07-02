//
//  NewsFeedSource.swift
//  ViperNews
//
//  Created by Тарас Минин on 02/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

protocol NewsFeedSourceProtocol {
    var name: String { get }
    var isEnabled: String { get }
    var feedUrl: String { get }
}

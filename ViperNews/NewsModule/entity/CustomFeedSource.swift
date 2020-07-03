//
//  CustomFeedSource.swift
//  ViperNews
//
//  Created by Тарас Минин on 04/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

final class GazetaNewsSource: BaseNewsSource {

    init() {
        super.init(feedUrl: "https://www.gazeta.ru/export/rss/lenta.xml",
                   name: "Gazeta Ru")
    }
}

final class LentaNewsSource: BaseNewsSource {

    init() {
        super.init(feedUrl: "https://lenta.ru/rss",
                   name: "Lenta Ru")
    }
}

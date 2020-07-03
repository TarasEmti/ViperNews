//
//  NewsFeedSource.swift
//  ViperNews
//
//  Created by Тарас Минин on 02/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

struct NewsSource {
    let name: String
    let feedUrl: String
    let isEnabled: Bool
}

extension CDNewsSource {

    func toNewsSource() -> NewsSource {

        guard let name = self.name, let urlString = self.feedUrl else {
            fatalError("NewsSource should not contain optionals")
        }
        let source = NewsSource(name: name,
                                feedUrl: urlString,
                                isEnabled: self.isEnabled)

        return source
    }
}

//
//  CDNewsItem+Ext.swift
//  ViperNews
//
//  Created by Тарас Минин on 03/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import UIKit

extension CDNewsItem {
    
    static let entityName = String(describing: CDNewsItem.self)

    func toNewsItem() -> NewsItem {

        var image: UIImage?
        if let data = self.image {
            image = UIImage(data: data)
        }

        return NewsItem(image: image,
                        imageUrl: imageUrl,
                        title: title!,
                        details: details!,
                        sourceName: sourceName!,
                        sourceUrl: sourceUrl!,
                        date: date!,
                        isUnread: isUnread)
    }

    func fill(with item: NewsItem) {
        image = item.image?.pngData()
        imageUrl = item.imageUrl
        title = item.title
        details = item.details
        sourceName = item.sourceName
        sourceUrl = item.sourceUrl
        date = item.date
        if isUnread == false {
            isUnread = false
        } else {
            isUnread = item.isUnread
        }
    }
}


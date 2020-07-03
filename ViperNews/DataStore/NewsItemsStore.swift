//
//  NewsItemsStore.swift
//  ViperNews
//
//  Created by Тарас Минин on 03/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import CoreData

protocol NewsItemsStoreProvider {
    func fetchNews(enabledSources: [NewsSource], completion: @escaping ([NewsItem]) -> Void)
    func save(news: [NewsItem])
}

final class NewsItemsStore: NewsItemsStoreProvider {

    private var mainContext: NSManagedObjectContext!
    private var privateContext: NSManagedObjectContext!

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ViperNews")
        container.loadPersistentStores { (desc, error) in
            print("Store container - \(desc)")
            if let error = error {
                print("Store Initialization error - \(error.localizedDescription)")
            }
        }

        return container
    }()

    init() {
        self.mainContext = persistentContainer.viewContext
        self.privateContext = persistentContainer.newBackgroundContext()
    }

    func fetchNews(enabledSources: [NewsSource], completion: @escaping ([NewsItem]) -> Void) {

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CDNewsItem.entityName)

        do {
            let result = try mainContext.fetch(fetchRequest) as! [CDNewsItem]
            let news = result.map { $0.toNewsItem() }
            completion(news)
        } catch {
            print(error)
        }
    }

    func save(news: [NewsItem]) {

        news.forEach { (item) in
            if let cdItem = newsItemExists(source: item.source, date: item.date) {
                cdItem.fill(with: item)
            } else {
                let newCdItem = NSEntityDescription.insertNewObject(
                    forEntityName: CDNewsItem.entityName,
                    into: privateContext
                ) as! CDNewsItem
                newCdItem.fill(with: item)
            }
        }

        do {
            try privateContext.save()
        } catch {
            print(error)
        }
    }

    private func newsItemExists(source: String, date: Date) -> CDNewsItem? {
        return nil
    }
}

import UIKit

private extension CDNewsItem {
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
                        source: source!,
                        date: date!)
    }

    func fill(with item: NewsItem) {
        image = item.image?.pngData()
        imageUrl = item.imageUrl
        isUnread = false
        title = item.title
        details = item.details
        source = item.source
        date = item.date
    }
}

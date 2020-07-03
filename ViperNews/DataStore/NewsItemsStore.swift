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

final class NewsItemsStore {

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

    private func newsItemExists(sourceUrl: URL, date: Date) -> CDNewsItem? {

        let request = NSFetchRequest<CDNewsItem>(entityName: CDNewsItem.entityName)
        request.predicate = NSPredicate(
            format: "sourceUrl = %@ AND date = %@",
            sourceUrl as NSURL,
            date as NSDate
        )

        do {
            let entity = try privateContext.fetch(request)

            return entity.first
        } catch {
            print(error)
        }

        return nil
    }
}

extension NewsItemsStore: NewsItemsStoreProvider {

    func fetchNews(enabledSources: [NewsSource], completion: @escaping ([NewsItem]) -> Void) {

        var news: [NewsItem] = []

        for source in enabledSources {

            let fetchRequest = NSFetchRequest<CDNewsItem>(entityName: CDNewsItem.entityName)
            fetchRequest.predicate = NSPredicate(format: "sourceUrl = %@", source.feedUrl)

            do {
                let result = try mainContext.fetch(fetchRequest)
                let sourceNews = result.map { $0.toNewsItem() }
                news.append(contentsOf: sourceNews)
            } catch {
                print(error)
            }
        }

        completion(news)
    }

    func save(news: [NewsItem]) {

        news.forEach { (item) in
            if let cdItem = newsItemExists(sourceUrl: item.sourceUrl, date: item.date) {
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
}

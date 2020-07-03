//
//  NewsFeedSource.swift
//  ViperNews
//
//  Created by Тарас Минин on 02/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

protocol NewsSource: NewsSourceLoading {
    var name: String { get }
    var feedUrl: String { get }
    var isEnabled: Bool { get set }
}

protocol NewsSourceLoading {
    var feedLoader: NewsLoading { get }
}

protocol NewsLoading {
    func loadFeed(completion: @escaping ([NewsItem]?, Error?) -> Void)
}

final class GazetaNewsSource: NewsSource {

    let name = "Gazeta RU"

    let feedUrl = "http://www.gazeta.ru/export/rss/lenta.xml"

    var isEnabled: Bool = true

    let feedLoader: NewsLoading

    init() {
        feedLoader = NewsLoader(urlString: feedUrl)
    }
}

final class LentaNewsSource: NewsSource {

    let name = "Lenta RU"

    let feedUrl = "https://lenta.ru/rss"

    var isEnabled: Bool = true

    let feedLoader: NewsLoading

    init() {
        feedLoader = NewsLoader(urlString: feedUrl)
    }
}

import Foundation

fileprivate class NewsLoader: NewsLoading {

    let url: URL

    init(urlString: String) {
        let url = URL(string: urlString)!
        self.url = url
    }

    func loadFeed(completion: @escaping ([NewsItem]?, Error?) -> Void) {

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let data = data {
                let rssParser = RssParser(data: data, sourceName: "LOLO")
                rssParser.parseFeed { (items) in
                    completion(items, error)
                }
            }
            print(data, response, error)
        }

        task.resume()
    }
}

extension NewsLoader {
    private final class RssParser: NSObject, XMLParserDelegate {

        private let parser: XMLParser
        private let sourceName: String
        private var items: [NewsItem] = []

        private var parseCompletion: (([NewsItem]) -> Void)!

        init(data: Data, sourceName: String) {
            parser = XMLParser(data: data)
            self.sourceName = sourceName
            super.init()

            parser.delegate = self
        }

        private struct UnfinishedNewsItem {
            var title: String = ""
            var details: String = ""
            var date: String = ""

            func toNewsItem(source: String) -> NewsItem? {
                guard
                    !title.isEmpty,
                    !details.isEmpty else {

                    return nil
                }

                let item = NewsItem(image: nil,
                                    title: title,
                                    details: details,
                                    source: source,
                                    date: Date())

                return item
            }
        }

        private var currentElement = ""
        private var currentItem: UnfinishedNewsItem?

        func parseFeed(completion: @escaping([NewsItem]) -> Void) {
            parseCompletion = completion
            parser.parse()
        }

        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

            currentElement = elementName
            if elementName == "item" {
                currentItem = UnfinishedNewsItem()
            }
        }

        func parser(_ parser: XMLParser, foundCharacters string: String) {
            switch currentElement {
            case "title":
                currentItem?.title += string.trimmingCharacters(in: .whitespacesAndNewlines)
            case "description":
                currentItem?.details += string.trimmingCharacters(in: .whitespacesAndNewlines)
            case "pubdate":
                currentItem?.date += string.trimmingCharacters(in: .whitespacesAndNewlines)
            default:
                return
            }
        }

        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

            if elementName == "item" {
                if let item = currentItem?.toNewsItem(source: sourceName) {
                    items.append(item)
                } else {
                    print("Failed to parse \(currentItem)")
                }
            }
        }

        func parserDidEndDocument(_ parser: XMLParser) {
            parseCompletion(items)
        }
    }
}

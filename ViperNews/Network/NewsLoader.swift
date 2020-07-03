//
//  NewsLoader.swift
//  ViperNews
//
//  Created by Тарас Минин on 03/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import Foundation

protocol NewsLoading {
    func loadFeed(completion: @escaping ([NewsItem]?, Error?) -> Void)
}

final class NewsLoader: NewsLoading {

    private let url: URL

    init(urlString: String) {
        let url = URL(string: urlString)!
        self.url = url
    }

    func loadFeed(completion: @escaping ([NewsItem]?, Error?) -> Void) {

        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in

            if let data = data {
                let rssParser = RssParser(data: data, sourceUrl: self.url)
                rssParser.parseFeed { (items) in
                    completion(items, error)
                }
            } else if let error = error {
                completion(nil, error)
            }
        }

        task.resume()
    }
}

extension NewsLoader {
    private final class RssParser: NSObject, XMLParserDelegate {

        private let parser: XMLParser
        private let sourceUrl: URL
        private var items: [NewsItem] = []

        private var parseCompletion: (([NewsItem]) -> Void)!

        init(data: Data, sourceUrl: URL) {
            parser = XMLParser(data: data)
            self.sourceUrl = sourceUrl
            super.init()

            parser.delegate = self
        }

        private struct UnfinishedNewsItem {
            let sourceUrl: URL
            var title: String = ""
            var details: String = ""
            var date: String = ""
            var imageUrl: String = ""

            init(sourceUrl: URL) {
                self.sourceUrl = sourceUrl
            }

            func toNewsItem(source: String) -> NewsItem? {
                guard
                    !title.isEmpty,
                    !details.isEmpty,
                    let date = Date.fromRssDateString(dateString: date) else {

                    return nil
                }

                let item = NewsItem(imageUrl: URL(string: imageUrl),
                                    title: title,
                                    details: details,
                                    sourceName: source,
                                    sourceUrl: sourceUrl,
                                    date: date,
                                    isUnread: true)

                return item
            }
        }

        private var currentElement = ""
        private var currentItem: UnfinishedNewsItem?

        private var isInChannelElement = false
        private var channelTitle = ""

        func parseFeed(completion: @escaping([NewsItem]) -> Void) {
            parseCompletion = completion
            parser.parse()
        }

        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

            currentElement = elementName
            if elementName == "item" {
                currentItem = UnfinishedNewsItem(sourceUrl: sourceUrl)
            } else if elementName == "channel" {
                isInChannelElement = true
            }
        }

        func parser(_ parser: XMLParser, foundCharacters string: String) {

            switch currentElement {
            case "title":
                if isInChannelElement {
                    channelTitle += string.trimmingCharacters(in: .newlines)
                } else {
                    currentItem?.title += string.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            case "description":
                currentItem?.details += string.trimmingCharacters(in: .whitespacesAndNewlines)
            case "pubDate":
                currentItem?.date += string.trimmingCharacters(in: .newlines)
            case "enclosure":
                currentItem?.imageUrl += string.trimmingCharacters(in: .whitespacesAndNewlines)
            default:
                return
            }
        }

        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

            if elementName == "title" {
                isInChannelElement = false
            }

            guard
                elementName == "item",
                let item = currentItem?.toNewsItem(source: channelTitle) else {
                    return
            }
            items.append(item)
        }

        func parserDidEndDocument(_ parser: XMLParser) {
            parseCompletion(items)
        }
    }
}

private extension Date {
    static func fromRssDateString(dateString: String) -> Date? {

        let df = DateFormatter()
        df.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        let date = df.date(from: dateString)

        return date
    }
}

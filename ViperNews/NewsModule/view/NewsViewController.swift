//
//  NewsViewController.swift
//  ViperNews
//
//  Created by Тарас Минин on 02/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import Foundation
import UIKit

final class NewsViewController: UIViewController {

    var presenter: ViewToPresenterProtocol?

    var newsArray: [NewsItem] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(with: NewsTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.dataSource = self

        return tableView
    }()

    private lazy var settingsBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Settings",
                                     style: .plain,
                                     target: self,
                                     action: #selector(showSettings))

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(tableView)

        title = "VIPER News"
        navigationItem.rightBarButtonItem = settingsBarButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.fetchNews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
    }

    @objc
    private func showSettings() {
        presenter?.showSettings()
    }
}

extension NewsViewController: PresenterToViewProtocol {

    func show(news: [NewsItem]) {
        newsArray = news
        tableView.reloadData()
    }

    func showError(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
}

extension NewsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let newsItem = newsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(with: NewsTableViewCell.self)
        cell.fill(with: newsItem)

        return cell
    }
}

extension NewsViewController {

    private final class NewsTableViewCell: UITableViewCell {

        private enum LayoutConstants {
            static let imageSide: CGFloat = 40
            static let vOffset: CGFloat = 20
        }

        private lazy var newsImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .lightGray
            imageView.layer.cornerRadius = 4

            return imageView
        }()

        private lazy var newsTitleLabel: UILabel = {
            let label = UILabel()
            label.font = .boldSystemFont(ofSize: 17)
            label.textColor = .black
            label.numberOfLines = 0

            return label
        }()

        private lazy var dateLabel: UILabel = {
            let label = UILabel()
            label.font = .italicSystemFont(ofSize: 14)
            label.textColor = .gray

            return label
        }()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)

            contentView.addSubview(newsImageView)
            contentView.addSubview(newsTitleLabel)
            contentView.addSubview(dateLabel)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func fill(with entity: NewsItem) {
            newsImageView.image = entity.image
            newsTitleLabel.text = entity.title
            dateLabel.text = "Date: \(entity.date.toNewsDateFormat())"
        }

        override func layoutSubviews() {

            let xOffset: CGFloat = layoutMargins.left

            newsImageView.frame = CGRect(x: xOffset,
                                         y: LayoutConstants.vOffset,
                                         width: LayoutConstants.imageSide,
                                         height: LayoutConstants.imageSide)

            let labelsWidh: CGFloat = contentView.bounds.width - xOffset*3 - newsImageView.frame.width
            let labelsCalcSize = CGSize(width: labelsWidh,
                                        height: CGFloat.greatestFiniteMagnitude)

            let titleSize = newsTitleLabel.sizeThatFits(labelsCalcSize)
            newsTitleLabel.frame = CGRect(x: newsImageView.frame.maxX + xOffset,
                                          y: LayoutConstants.vOffset,
                                          width: labelsWidh,
                                          height: titleSize.height)

            let sourceHeight = dateLabel.sizeThatFits(labelsCalcSize).height
            dateLabel.frame = CGRect(x: newsTitleLabel.frame.minX,
                                       y: newsImageView.frame.maxY - sourceHeight,
                                       width: labelsWidh,
                                       height: sourceHeight)
        }

        override func sizeThatFits(_ size: CGSize) -> CGSize {
            contentView.bounds = CGRect(origin: .zero, size: size)
            setNeedsLayout()
            layoutIfNeeded()

            return CGSize(width: size.width,
                          height: newsImageView.frame.maxY + LayoutConstants.vOffset)
        }
    }
}

private extension Date {
    func toNewsDateFormat() -> String {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/YYYY HH:mm"

        return df.string(from: self)
    }
}

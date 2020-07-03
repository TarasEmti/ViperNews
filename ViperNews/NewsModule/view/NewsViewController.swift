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

        func fill(with entity: NewsItem) {
            // TODO
        }
    }
}

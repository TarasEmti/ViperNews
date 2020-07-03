//
//  SettingsViewController.swift
//  ViperNews
//
//  Created by Тарас Минин on 03/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        tableView.dataSource = self

        return tableView
    }()

    private let newsSources: NewsFeedSourceProvidable = NewsSourcesProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return newsSources.allFeedSources().count
        case 1:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")

        switch indexPath.section {
        case 0:
            let source = newsSources.allFeedSources()[indexPath.row]
            cell.textLabel?.text = source.name
            cell.detailTextLabel?.text = source.feedUrl
            let switchView = UISwitch()
            switchView.isOn = source.isEnabled
            switchView.addTarget(source, action: #selector(NewsSource.toggleIsEnabled), for: .valueChanged)
            cell.accessoryView = switchView
            cell.selectionStyle = .none

        case 1:
            cell.textLabel?.text = "Feed autoupdate time"
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }

        return cell
    }
}

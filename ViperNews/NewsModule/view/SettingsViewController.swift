//
//  SettingsViewController.swift
//  ViperNews
//
//  Created by Тарас Минин on 03/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {

    weak var router: NewsCoordinatorRouter?

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    private let newsSources: NewsFeedSourceProvidable = NewsSourcesProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        view.addSubview(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
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

        switch indexPath.section {
        case 0:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)

            let source = newsSources.allFeedSources()[indexPath.row]
            cell.textLabel?.text = source.name
            cell.detailTextLabel?.text = source.feedUrl
            let switchView = UISwitch()
            switchView.isOn = source.isEnabled
            switchView.addTarget(source, action: #selector(NewsSource.toggleIsEnabled), for: .valueChanged)
            cell.accessoryView = switchView
            cell.selectionStyle = .none

            return cell
        case 1:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            let updateTimer = SettingsServiceImpl.shared().feedUpdateTimer

            cell.textLabel?.text = "Feed autoupdate time"
            cell.detailTextLabel?.text = String(format: "%0.f sec", updateTimer)
            cell.accessoryType = .disclosureIndicator

            return cell
        default:
            fatalError("Unrecognized inde ")
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            if indexPath.row == 0 {
                router?.showUpdateTimerSettings()
            }
        default:
            return
        }
    }
}

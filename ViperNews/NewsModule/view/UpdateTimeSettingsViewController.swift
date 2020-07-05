//
//  UpdateTimeSettingsViewController.swift
//  ViperNews
//
//  Created by Тарас Минин on 05/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import UIKit

final class UpdateTimeSettingsViewController: UIViewController {

    weak var router: NewsCoordinatorRouter?

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    private let settings = SettingsServiceImpl.shared()
    private let dataSource = SettingsServiceImpl.FeedUpdateTimer.allCases
    private var selectedIndex: IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Feed Update"
        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
}

extension UpdateTimeSettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)

        let timer = dataSource[indexPath.row]
        cell.textLabel?.text = String(format: "%.0f sec", timer.rawValue)

        if timer.rawValue == settings.feedUpdateTimer {
            selectedIndex = indexPath
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
}

extension UpdateTimeSettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let prevCell = tableView.cellForRow(at: selectedIndex)
        prevCell?.accessoryType = .none

        let timer = dataSource[indexPath.row]
        settings.setUpdateTimer(time: timer.rawValue)

        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        selectedIndex = indexPath
    }
}


//
//  NotificationViewController.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import Combine
import UIKit

class NotificationViewController: UITableViewController {
    let viewModel: NotificationViewModel
    weak var coordinator: NotificationCoordinator?

    required init(viewModel: NotificationViewModel, coordinator: NotificationCoordinator?) {
        self.viewModel = viewModel
        self.coordinator = coordinator

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        coordinator?.finish()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupStyle()
        setupBinding()
    }

    private func setupStyle() {
        navigationItem.title = "Notification"
        tableView.backgroundColor = .customBG
        tableView.separatorStyle = .none
    }

    private func setupTableView() {
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.reuseIdentifier)
        tableView.dataSource = self
    }

    private func setupBinding() {
        let output = viewModel.transform(.init(), cancellables: &cancellables)
        output.notifications
            .sink { [weak self] _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self?.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }

    private var cancellables: Set<AnyCancellable> = []
}

extension NotificationViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notifications.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.reuseIdentifier) as? NotificationCell else {
            return UITableViewCell()
        }

        let notification = viewModel.notifications[indexPath.row]
        var hasRead = false
        if let lastReadTime = viewModel.lastReadTime, notification.updateDateTime.compare(lastReadTime) == .orderedAscending {
            hasRead = true
        }
        cell.configure(viewModel: .init(title: notification.title,
                                        message: notification.message,
                                        timestamp: notification.updateDateTime,
                                        hasRead: hasRead))
        return cell
    }
}

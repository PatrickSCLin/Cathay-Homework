//
//  MainCoodinator.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import UIKit

final class MainCoordinator: Coordinatable {
    weak var parent: Coordinatable?
    var children: [Coordinatable]
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.children = []
        self.navigationController = navigationController
    }

    func start() {
        let viewController = MainViewController(viewModel: .init(), coordinator: self)
        navigationController.pushViewController(viewController, animated: false)
    }

    func showNotifications() {
        let coordinator = NotificationCoordinator(navigationController: navigationController)
        coordinator.parent = self
        children.append(coordinator)
        coordinator.start()
    }
}

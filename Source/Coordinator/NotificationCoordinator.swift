//
//  NotificationCoordinator.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/23.
//

import UIKit

final class NotificationCoordinator: Coordinatable {
    weak var parent: Coordinatable?
    var children: [Coordinatable]
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.children = []
        self.navigationController = navigationController
    }

    func start() {
        let viewController = NotificationViewController(viewModel: .init(), coordinator: self)
        navigationController.pushViewController(viewController, animated: false)
    }
}

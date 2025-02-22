//
//  AppCoordinator.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import UIKit

final class AppCoordinator: Coordinatable {
    private(set) var children: [Coordinatable]
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.children = []
        self.navigationController = navigationController
    }

    func start() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        children.append(mainCoordinator)
        mainCoordinator.start()
    }
}

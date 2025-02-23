//
//  AppCoordinator.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import UIKit

final class AppCoordinator: Coordinatable {
    weak var parent: Coordinatable?
    var children: [Coordinatable]
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.children = []
        self.navigationController = navigationController

        let backImage = UIImage(named: "back_arrow")?.withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        UIBarButtonItem.appearance()
            .setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor.clear
            ], for: .normal)
        UIBarButtonItem.appearance()
    }

    func start() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        mainCoordinator.parent = self
        children.append(mainCoordinator)
        mainCoordinator.start()
    }

    func finish() {}
}

//
//  NavigationController.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/23.
//

import UIKit

class NavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)

        viewController.navigationItem.backButtonTitle = ""
    }
}

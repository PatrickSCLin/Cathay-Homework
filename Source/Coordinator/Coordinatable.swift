//
//  Coordinator.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import UIKit

protocol Coordinatable: AnyObject {
    var children: [Coordinatable] { get }
    var navigationController: UINavigationController { get }
    func start()
}

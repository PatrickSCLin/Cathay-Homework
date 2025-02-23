//
//  Coordinator.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import UIKit

protocol Coordinatable: AnyObject {
    var parent: Coordinatable? { get }
    var children: [Coordinatable] { get set }
    var navigationController: UINavigationController { get }
    func start()
    func finish()
}

extension Coordinatable {
    func finish() {
        children.forEach { $0.finish() }
        children.removeAll()
        parent?.children.removeAll { $0 === self }
    }
}

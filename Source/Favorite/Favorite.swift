//
//  Favorite.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/21.
//

import UIKit

enum Favorite: String, CaseIterable {
    case contacts
    case insurance
    case creditCard
    case branches
    case extra

    var title: String {
        switch self {
        case .contacts:
            return "Contacts"
        case .insurance:
            return "Insurance"
        case .creditCard:
            return "Credit Card"
        case .branches:
            return "Branches"
        case .extra:
            return "I'm extra"
        }
    }

    var image: UIImage {
        switch self {
        case .contacts:
            return .init(named: "contacts")!
        case .insurance:
            return .init(named: "insurance")!
        case .creditCard:
            return .init(named: "credit_card")!
        case .branches:
            return .init(named: "branches")!
        case .extra:
            return .init(named: "insurance")!
        }
    }
}

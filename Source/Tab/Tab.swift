//
//  Tab.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/21.
//

import UIKit

enum Tab {
    static let selectedTintColor: UIColor = .orange
    static let tintColor: UIColor = .systemGray

    case home
    case account
    case location
    case service

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .account:
            return "Account"
        case .location:
            return "Location"
        case .service:
            return "Service"
        }
    }

    var image: UIImage {
        switch self {
        case .home:
            return .init(named: "tab_home")!
        case .account:
            return .init(named: "tab_account")!
        case .location:
            return .init(named: "tab_location")!
        case .service:
            return .init(named: "tab_service")!
        }
    }
}

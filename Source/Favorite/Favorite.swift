//
//  Favorite.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/21.
//

import UIKit

enum FavoriteType: String, CaseIterable {
    case cubc = "CUBC"
    case mobile = "Mobile"
    case pmf = "PMF"
    case creditCard = "CreditCard"

    var image: UIImage {
        switch self {
        case .cubc:
            return .init(named: "favorite_cubc")!
        case .mobile:
            return .init(named: "favorite_mobile")!
        case .pmf:
            return .init(named: "favorite_pmf")!
        case .creditCard:
            return .init(named: "favorite_credit_card")!
        }
    }
}

//
//  Banner.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/21.
//

import UIKit

enum Banner {
    case banner1
    case banner2
    case banner3

    var image: UIImage {
        switch self {
        case .banner1:
            return .init(named: "ads_1")!
        case .banner2:
            return .init(named: "ads_2")!
        case .banner3:
            return .init(named: "ads_3")!
        }
    }
}

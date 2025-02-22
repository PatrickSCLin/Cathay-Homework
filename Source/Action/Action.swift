//
//  Action.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/20.
//

import UIKit

enum Action {
    case transfer
    case payment
    case utility
    case qrcodeScan
    case qrcodePay
    case topUp

    var title: String {
        switch self {
        case .transfer:
            return "Transfer"
        case .payment:
            return "Payment"
        case .utility:
            return "Utility"
        case .qrcodeScan:
            return "QR pay scan"
        case .qrcodePay:
            return "My QR code"
        case .topUp:
            return "Top up"
        }
    }

    var image: UIImage {
        switch self {
        case .transfer:
            return .init(named: "transfer")!
        case .payment:
            return .init(named: "payment")!
        case .utility:
            return .init(named: "utility")!
        case .qrcodeScan:
            return .init(named: "scan")!
        case .qrcodePay:
            return .init(named: "qrcode")!
        case .topUp:
            return .init(named: "top_up")!
        }
    }
}

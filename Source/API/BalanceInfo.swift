//
//  BalanceInfo.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/20.
//

struct AccountInfo: Codable, Hashable {
    let account: String
    let curr: String
    let balance: Double
}

struct BalanceInfo: Hashable {
    let currency: Currency
    let balance: Double
    let saving: [AccountInfo]
    let fixedDeposit: [AccountInfo]
    let digital: [AccountInfo]

    static func == (lhs: BalanceInfo, rhs: BalanceInfo) -> Bool {
        return lhs.currency == rhs.currency && lhs.balance == rhs.balance
    }
}

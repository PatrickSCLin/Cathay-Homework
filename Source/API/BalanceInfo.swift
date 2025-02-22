//
//  BalanceInfo.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/20.
//

struct AccountInfo: Codable {
    let account: String
    let curr: String
    let balance: Double
}

struct BalanceInfo {
    let currency: Currency
    let balance: Double
    let saving: [AccountInfo]
    let fixedDeposit: [AccountInfo]
    let digital: [AccountInfo]
}

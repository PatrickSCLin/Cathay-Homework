//
//  BalanceModel.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/23.
//

import Foundation
import SwiftData

@Model
final class BalanceModel: Hashable {
    @Attribute(.unique)
    var currencyRawValue: String
    var currency: Currency {
        get {
            Currency(rawValue: currencyRawValue) ?? .usd
        }
        set {
            currencyRawValue = newValue.rawValue
        }
    }

    var balance: Double

    init(currency: Currency, balance: Double) {
        self.currencyRawValue = currency.rawValue
        self.balance = balance
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(currencyRawValue)
        hasher.combine(balance)
    }

    static func == (lhs: BalanceModel, rhs: BalanceModel) -> Bool {
        return lhs.currencyRawValue == rhs.currencyRawValue && lhs.balance == rhs.balance
    }
}

extension BalanceModel {
    static func fetchAll() -> [BalanceModel] {
        var result = [BalanceModel]()
        for currency in Currency.allCases {
            if let balance = Self.fetch(currency: currency) {
                result.append(balance)
            }
        }
        return result
    }

    static func fetch(currency: Currency) -> BalanceModel? {
        let currentRawValue = currency.rawValue
        var descriptor = FetchDescriptor<BalanceModel>()
        descriptor.predicate = #Predicate<BalanceModel> { $0.currencyRawValue == currentRawValue }
        return try? Database.shared.context.fetch(descriptor).first
    }
}

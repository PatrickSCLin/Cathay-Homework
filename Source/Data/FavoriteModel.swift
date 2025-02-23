//
//  FavoriteModel.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/23.
//

import Foundation
import SwiftData

@Model
final class FavoriteModel: Hashable {
    var nickname: String
    var transTypeRawValue: String
    @Attribute(.unique)
    var index: Int

    var transType: FavoriteType {
        get {
            FavoriteType(rawValue: transTypeRawValue) ?? .cubc
        }
        set {
            transTypeRawValue = newValue.rawValue
        }
    }

    init(nickname: String, transType: FavoriteType, index: Int) {
        self.nickname = nickname
        self.transTypeRawValue = transType.rawValue
        self.index = index
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(nickname)
        hasher.combine(transTypeRawValue)
        hasher.combine(index)
    }

    static func == (lhs: FavoriteModel, rhs: FavoriteModel) -> Bool {
        return lhs.nickname == rhs.nickname &&
            lhs.transTypeRawValue == rhs.transTypeRawValue &&
            lhs.index == rhs.index
    }
}

extension FavoriteModel {
    static func fetchAll() -> [FavoriteModel] {
        var descriptor = FetchDescriptor<FavoriteModel>()
        descriptor.sortBy = [SortDescriptor(\.index, order: .forward)]
        return (try? Database.shared.context.fetch(descriptor)) ?? []
    }
}

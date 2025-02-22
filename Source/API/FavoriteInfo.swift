//
//  FavoriteInfo.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/22.
//

struct FavoriteInfo: Decodable {
    let nickname: String
    let transType: String
}

struct FavoritesInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case result
        case favoriteList
    }

    let favorites: [FavoriteInfo]

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let resultContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
        self.favorites = try resultContainer.decode([FavoriteInfo].self, forKey: .favoriteList)
    }
}

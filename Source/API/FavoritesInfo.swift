//
//  FavoritesInfo.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/22.
//

struct FavoriteInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case nickname
        case transType
    }

    let nickname: String
    let transType: FavoriteType

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.nickname = try container.decode(String.self, forKey: .nickname)

        guard let typeString = try? container.decode(String.self, forKey: .transType),
              let favoriteType = FavoriteType(rawValue: typeString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .transType,
                in: container,
                debugDescription: "Could not parse transType string"
            )
        }

        self.transType = favoriteType
    }
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

//
//  BannersInfo.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/22.
//

struct BannerInfo: Decodable, Hashable {
    let adSeqNo: Int
    let linkUrl: String
}

struct BannersInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case result
        case bannerList
    }

    let banners: [BannerInfo]

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
        self.banners = try nestedContainer.decode([BannerInfo].self, forKey: .bannerList)
    }
}

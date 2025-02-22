//
//  SavingInfo.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/20.
//

struct SavingInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case result
        case savingsList
    }

    let accounts: [AccountInfo]

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let resultContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
        self.accounts = try resultContainer.decode([AccountInfo].self, forKey: .savingsList)
    }
}

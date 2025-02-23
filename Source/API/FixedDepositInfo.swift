//
//  FixedDepositInfo.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/20.
//

struct FixedDepositInfo: Decodable, Hashable {
    enum CodingKeys: String, CodingKey {
        case result
        case fixedDepositList
    }

    let accounts: [AccountInfo]

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let resultContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
        self.accounts = try resultContainer.decode([AccountInfo].self, forKey: .fixedDepositList)
    }
}

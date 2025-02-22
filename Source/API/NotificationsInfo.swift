//
//  NotificationInfo.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/22.
//

import Foundation

struct NotificationInfo: Decodable {
    let status: Bool
    let updateDateTime: Date
    let title: String
    let message: String

    enum CodingKeys: String, CodingKey {
        case status
        case updateDateTime
        case title
        case message
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(Bool.self, forKey: .status)
        title = try container.decode(String.self, forKey: .title)
        message = try container.decode(String.self, forKey: .message)

        let dateString = try container.decode(String.self, forKey: .updateDateTime)

        let formatter = DateFormatter()

        let dateFormats = [
            "yyyy/MM/dd HH:mm:ss",
            "HH:mm:ss yyyy/MM/dd"
        ]

        for format in dateFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                updateDateTime = date
                return
            }
        }

        throw DecodingError.dataCorruptedError(
            forKey: .updateDateTime,
            in: container,
            debugDescription: "Could not parse date string: \(dateString)"
        )
    }
}

struct NotificationsInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case result
        case messages
    }

    let notifications: [NotificationInfo]

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let resultContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
        notifications = try resultContainer.decode([NotificationInfo].self, forKey: .messages)
    }
}

//
//  UserDefaults+Extension.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/21.
//

import Foundation

extension UserDefaults {
    var isFirstOpen: Bool {
        get { bool(forKey: Keys.isFirstOpen) }
        set { set(newValue, forKey: Keys.isFirstOpen) }
    }

    var currentBannerIndex: Int {
        get { integer(forKey: Keys.currentBannerIndex) }
        set { set(newValue, forKey: Keys.currentBannerIndex) }
    }

    var lastNotificationReadTime: Date? {
        get { object(forKey: Keys.lastNotificationReadTime) as? Date }
        set { set(newValue, forKey: Keys.lastNotificationReadTime) }
    }

    private enum Keys {
        static let isFirstOpen = "is_first_open"
        static let currentBannerIndex = "current_banner_index"
        static let lastNotificationReadTime = "last_notification_read_time"
    }
}

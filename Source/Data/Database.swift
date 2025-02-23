//
//  Database.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/23.
//

import SwiftData

final class Database {
    static let shared = Database()

    let container: ModelContainer
    let context: ModelContext

    private init() {
        do {
            let schema = Schema([
                NotificationModel.self,
                BalanceModel.self,
                FavoriteModel.self
            ])
            let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [configuration])
            context = ModelContext(container)
        } catch {
            fatalError("Database initialization failed: \(error)")
        }
    }
}

extension Database {
    func save<T: PersistentModel>(_ objects: [T]) {
        objects.forEach { context.insert($0) }
        try? context.save()
    }
}

//
//  BannerCellViewModel.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import Combine
import Foundation

final class BannerCellViewModel: ViewModelType {
    struct Input {}

    struct Output {
        let banners: AnyPublisher<[Banner], Never>
    }

    init(banners: [Banner]) {
        bannersSubject = .init(banners)
    }

    var banners: [Banner] { bannersSubject.value }

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        return .init(banners: bannersSubject.eraseToAnyPublisher())
    }

    private let bannersSubject: CurrentValueSubject<[Banner], Never>
}

//
//  BannerCellViewModel.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import Combine
import Foundation
import UIKit

typealias Banner = (seq: Int, image: UIImage)

final class BannerCellViewModel: ViewModelType {
    struct Input {}

    struct Output {
        let banners: AnyPublisher<[Banner], Never>
    }

    init(bannerInfos: [BannerInfo]) {
        bannersSubject = .init([])
        bannerInfosSubject = .init(bannerInfos)
    }

    var banners: [Banner] { bannersSubject.value }

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        let bannersPublisher = bannerInfosSubject
            .flatMap { bannerInfos in
                Publishers.MergeMany(
                    bannerInfos.map { bannerInfo in
                        self.downloadImage(from: bannerInfo.linkUrl)
                            .map { image in (bannerInfo.adSeqNo, image) }
                    }
                )
                .collect(bannerInfos.count)
            }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .compactMap { banners -> [Banner]? in
                let validBanners = banners.compactMap { seq, image -> Banner? in
                    guard let image = image else { return nil }

                    return Banner(seq: seq, image: image)
                }
                return validBanners.sorted { $0.seq < $1.seq }
            }
            .eraseToAnyPublisher()

        return .init(banners: bannersPublisher)
    }

    private func downloadImage(from urlString: String) -> AnyPublisher<UIImage?, Never> {
        if let cachedImage = BannerCellViewModel.imageCache.object(forKey: urlString as NSString) {
            return Just(cachedImage).eraseToAnyPublisher()
        }

        guard let url = URL(string: urlString) else {
            return Just(nil).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, _ in UIImage(data: data) }
            .handleEvents(receiveOutput: { image in
                if let image = image {
                    BannerCellViewModel.imageCache.setObject(image, forKey: urlString as NSString)
                }
            })
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }

    private let bannersSubject: CurrentValueSubject<[Banner], Never>
    private let bannerInfosSubject: CurrentValueSubject<[BannerInfo], Never>
    private static let imageCache = NSCache<NSString, UIImage>()
}

//
//  CarouselViewModel.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/21.
//

import Combine
import Foundation
import UIKit

final class CarouselViewModel: ViewModelType {
    struct Input {
        let viewDidAppear: AnyPublisher<Void, Never>
        let viewDidEndDecelerating: AnyPublisher<Int, Never>
        let viewWillBeginDragging: AnyPublisher<Void, Never>
    }

    struct Output {
        let images: AnyPublisher<[UIImage], Never>
        let currentIndex: AnyPublisher<Int, Never>
    }

    var images: [UIImage] { imagesSubject.value }
    var currentIndex: Int { currentIndexSubject.value }

    init(images: [UIImage], currentIndex: Int) {
        self.imagesSubject = .init(images)
        self.currentIndexSubject = .init(currentIndex)
    }

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        let timer = Timer.publish(every: 3, on: .main, in: .common)
            .autoconnect()
            .share()

        let isUserInteractingSubject = CurrentValueSubject<Bool, Never>(false)

        Publishers.Merge(
            input.viewWillBeginDragging.map { _ in true },
            input.viewDidEndDecelerating.map { _ in false }
        )
        .subscribe(isUserInteractingSubject)
        .store(in: &cancellables)

        input.viewDidEndDecelerating
            .flatMap { index -> AnyPublisher<Int, Never> in
                Just(index)
                    .delay(for: .seconds(3), scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] index in
                guard let self else { return }

                self.currentIndexSubject.send((index + 1) % (self.imagesSubject.value.count))
            }
            .store(in: &cancellables)

        timer
            .filter { _ in !isUserInteractingSubject.value }
            .sink { [weak self] _ in
                guard let self else { return }

                let nextIndex = (currentIndexSubject.value + 1) % self.imagesSubject.value.count
                currentIndexSubject.send(nextIndex)
            }
            .store(in: &cancellables)

        return Output(
            images: imagesSubject.eraseToAnyPublisher(),
            currentIndex: currentIndexSubject.eraseToAnyPublisher()
        )
    }

    private let imagesSubject: CurrentValueSubject<[UIImage], Never>
    private let currentIndexSubject: CurrentValueSubject<Int, Never>
}

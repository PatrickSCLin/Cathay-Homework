//
//  ViewModelType.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/20.
//

import Combine

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output
}

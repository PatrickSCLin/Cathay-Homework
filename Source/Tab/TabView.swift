//
//  TabView.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/21.
//

import Combine
import UIKit

class TabView: UIView {
    let viewModel: TabViewModel

    required init(viewModel: TabViewModel) {
        self.viewModel = viewModel

        super.init(frame: .zero)

        setupStyle()
        setupLayout()
        setupBinding()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        backgroundColor = .white
        layer.cornerRadius = 25
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.masksToBounds = false
    }

    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: itemViews)
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.alignment = .fill

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    private func setupBinding() {
        let output = viewModel.transform(.init(), cancellables: &cancellables)
        output.tabs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tabs in self?.configureTabs(tabs) }
            .store(in: &cancellables)
    }

    private func configureTabs(_ tabs: [Tab]) {
        for (index, tab) in tabs.enumerated() {
            let itemView = itemViews[index]
            itemView.configure(viewModel: .init(title: tab.title,
                                                image: tab.image,
                                                isSelected: viewModel.selectedIndex == index))
        }
    }

    private lazy var itemViews: [TabItemView] = {
        var views = [TabItemView]()
        for tab in viewModel.tabs {
            views.append(TabItemView())
        }
        return views
    }()

    private var cancellables: Set<AnyCancellable> = []
}

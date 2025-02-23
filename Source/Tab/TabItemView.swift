//
//  TabItemView.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/21.
//

import Combine
import UIKit

class TabItemView: UIView {
    var viewModel: TabItemViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: TabItemViewModel) {
        self.viewModel = viewModel
        
        let output = viewModel.transform(.init(), cancellables: &cancellables)

        output.title
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.titleLabel.text = $0 }
            .store(in: &cancellables)
            
        output.image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.imageView.image = $0 }
            .store(in: &cancellables)
            
        output.isSelected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSelected in
                self?.titleLabel.textColor = isSelected ? Tab.selectedTintColor : Tab.tintColor
                self?.imageView.tintColor = isSelected ? Tab.selectedTintColor : Tab.tintColor
            }
            .store(in: &cancellables)
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 70),
            heightAnchor.constraint(equalToConstant: 50),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        // TODO: Not requried implemetation in homework
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = Tab.tintColor
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .style7
        label.textColor = Tab.tintColor
        return label
    }()
    
    private var cancellables: Set<AnyCancellable> = []
}

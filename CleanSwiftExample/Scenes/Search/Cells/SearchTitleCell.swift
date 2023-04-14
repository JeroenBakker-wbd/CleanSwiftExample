//
//  SearchTitleCell.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import UIKit

final class SearchTitleCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = String(describing: type(of: SearchTitleCell.self))
    
    private lazy var titleLabel: UILabel = makeTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented, we do not want storyboards")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        update(with: nil)
    }
}

// MARK: - Updatable
extension SearchTitleCell {
        
    func update(with viewModel: ViewModel?) {
        titleLabel.text = viewModel?.title
    }
}

// MARK: - Private setup methods
private extension SearchTitleCell {
    
    func setup() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(lessThanOrEqualTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - Views
private extension SearchTitleCell {
    
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }
}

// MARK: - ViewModel
extension SearchTitleCell {
    
    struct ViewModel: Equatable {
        private(set) var uniqueId: String = UUID().uuidString
        let id: String
        let title: String
    }
}


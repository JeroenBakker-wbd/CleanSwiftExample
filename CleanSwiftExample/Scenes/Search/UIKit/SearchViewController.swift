//
//  SearchViewController.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import UIKit

final class SearchViewController: UIViewController, SearchViewInput {
    
    private lazy var spinnerView: UIActivityIndicatorView = makeSpinnerView()
    private lazy var retryButton: UIButton = makeRetryButton()
    
    private lazy var searchBar: UISearchBar = makeSearchBar()
    private lazy var titleLabel: UILabel = makeTitleLabel()
    
    private lazy var collectionView: UICollectionView = makeCollectionView()
    private lazy var dataSource: UICollectionViewDiffableDataSource<SearchDataSourceSection, SearchDataSourceItem> = makeDataSource()
    
    var output: (any SearchViewOutput)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        Task { await output.load(initialize: SearchLogic.Initialize.Request()) }
    }
}

// MARK: - SearchViewInput
extension SearchViewController {
    
    @MainActor
    func show(initalize viewModel: SearchLogic.Initialize.ViewModel) async {
        titleLabel.text = viewModel.greeting
    }
    
    @MainActor
    func show(loading viewModel: SearchLogic.Loading.ViewModel) async {
        if viewModel.showSpinner {
            spinnerView.startAnimating()
        } else {
            spinnerView.stopAnimating()
        }
    }
    
    @MainActor
    func show(error viewModel: SearchLogic.Error.ViewModel) async {
        titleLabel.text = viewModel.title
        
        retryButton.isHidden = false
        retryButton.titleLabel?.text = viewModel.ctaTitle
    }
    
    @MainActor
    func show(search viewModel: SearchLogic.Search.ViewModel) async {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.searchDataSourceItem, toSection: .main)
        await dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @MainActor
    func show(searchPagination viewModel: SearchLogic.SearchPagination.ViewModel) async {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(viewModel.searchDataSourceItem, toSection: .main)
        await dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Task { await output.load(search: SearchLogic.Search.Request(searchText: searchText)) }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        switch item {
        case .results(let viewModel):
            Task { await output.load(detail: SearchLogic.Detail.Request(id: viewModel.id)) }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height else {
            return
        }
        
        Task { await output.load(searchPagination: SearchLogic.SearchPagination.Request()) }
    }
}


// MARK: - Actions
private extension SearchViewController {
    
    @objc func didTapRetryButton(sender: UIButton) {
        Task { await output.load(retry: SearchLogic.Retry.Request()) }
    }
    
    @objc func didTapView() {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Setup
private extension SearchViewController {
    
    func setup() {
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(retryButton)
        view.addSubview(spinnerView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            spinnerView.topAnchor.constraint(equalTo: view.topAnchor),
            spinnerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spinnerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinnerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            retryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addGestureRecognizer(makeTapGesture())
    }
}

// MARK: - Views
private extension SearchViewController {
    
    func makeSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .default
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        return searchBar
    }
    
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeSpinnerView() -> UIActivityIndicatorView {
        let spinnerView = UIActivityIndicatorView()
        spinnerView.hidesWhenStopped = true
        spinnerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        return spinnerView
    }
    
    func makeRetryButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTapRetryButton(sender:)), for: .touchUpInside)
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func makeTapGesture() -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        tapGesture.cancelsTouchesInView = false
        return tapGesture
    }
    
    func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.register(SearchTitleCell.self, forCellWithReuseIdentifier: SearchTitleCell.reuseIdentifier)
        return collectionView
    }
    
    func makeCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(2/5))
            
            let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
            layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 0)
            
            let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(250))
            
            let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
            
            let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
            
            return layoutSection
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        layout.configuration = config
        return layout
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<SearchDataSourceSection, SearchDataSourceItem> {
        return .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .results(let viewModel):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath) as? SearchTitleCell else {
                    fatalError("Forgot to register SearchPhotosResultCell")
                }
                cell.update(with: viewModel)
                return cell
            }
        })
    }
}

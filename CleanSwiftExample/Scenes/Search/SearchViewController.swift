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
    
    var output: SearchViewOutput!
    
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
        // show results in a list
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
        view.addSubview(spinnerView)
        view.addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            spinnerView.topAnchor.constraint(equalTo: view.topAnchor),
            spinnerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spinnerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinnerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
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
}

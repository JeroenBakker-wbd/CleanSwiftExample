//
//  SearchViewController.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import UIKit

final class SearchViewController: UIViewController, SearchViewInput {
    
    private lazy var titleLabel: UILabel = makeTitleLabel()
    private lazy var spinnerView: UIActivityIndicatorView = makeSpinnerView()
    private lazy var retryButton: UIButton = makeRetryButton()
    
    var output: SearchViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        Task { await output.initalize(request: SearchLogic.Initialize.Request()) }
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
}

// MARK: - Actions
extension SearchViewController {
    
    @objc private func didTapRetryButton(sender: UIButton) {
        
    }
}

// MARK: - Setup
private extension SearchViewController {
    
    func setup() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(spinnerView)
        view.addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            spinnerView.topAnchor.constraint(equalTo: view.topAnchor),
            spinnerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spinnerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinnerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            retryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
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
}

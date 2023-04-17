//
//  SearchViewModel.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 17/04/2023.
//

import Foundation
import SwiftUI

final class SearchViewModel: ObservableObject, SearchViewInput {
    
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var title: String = ""
    @Published private(set) var retryButtonTitle: String?
    @Published private(set) var searchDataSourceItem: [SearchDataSourceItem] = []
    
    var output: SearchViewOutput?
}

// MARK: - SearchViewInput
extension SearchViewModel {
    
    @MainActor
    func show(initalize viewModel: SearchLogic.Initialize.ViewModel) async {
        title = viewModel.greeting
    }
    
    @MainActor
    func show(loading viewModel: SearchLogic.Loading.ViewModel) async {
        isLoading = viewModel.showSpinner
    }
    
    @MainActor
    func show(error viewModel: SearchLogic.Error.ViewModel) async {
        title = viewModel.title
        retryButtonTitle = viewModel.ctaTitle
    }
    
    @MainActor
    func show(search viewModel: SearchLogic.Search.ViewModel) async {
        searchDataSourceItem = viewModel.searchDataSourceItem
    }
    
    @MainActor
    func show(searchPagination viewModel: SearchLogic.SearchPagination.ViewModel) async {
        searchDataSourceItem.append(contentsOf: viewModel.searchDataSourceItem)
    }
}

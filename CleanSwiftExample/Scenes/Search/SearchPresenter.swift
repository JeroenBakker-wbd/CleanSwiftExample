//
//  SearchPresenter.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import Foundation

struct SearchPresenter: SearchPresentable, @unchecked Sendable {
    
    @Dependency(\.localisationMapper) private var localisationMapper
    
    weak var output: SearchPresenterOutput?
    
    func present(initalize response: SearchLogic.Initialize.Response) async {
        await output?.show(initalize: SearchLogic.Initialize.ViewModel(
            greeting: localisationMapper.map(key: .searchGreeting(firstName: response.user.firstName))
        ))
    }
    
    func present(loading response: SearchLogic.Loading.Response) async {
        await output?.show(loading: SearchLogic.Loading.ViewModel(
            showSpinner: response.isLoading
        ))
    }
    
    func present(error response: SearchLogic.Error.Response) async {
        await output?.show(error: SearchLogic.Error.ViewModel(
            title: localisationMapper.map(key: .searchGetUserError),
            ctaTitle: localisationMapper.map(key: .searchGetUserCTATitle)
        ))
    }
    
    func present(search response: SearchLogic.Search.Response) async {
        await output?.show(search: SearchLogic.Search.ViewModel(
            searchDataSourceItem: response.searchResults.map({ searchResult in
                SearchDataSourceItem.results(SearchTitleCell.ViewModel(
                    id: searchResult.id,
                    title: searchResult.title
                ))
            })
        ))
    }
    
    func present(searchPagination response: SearchLogic.SearchPagination.Response) async {
        await output?.show(searchPagination: SearchLogic.SearchPagination.ViewModel(
            searchDataSourceItem: response.searchResults.map({ searchResult in
                SearchDataSourceItem.results(SearchTitleCell.ViewModel(
                    id: searchResult.id,
                    title: searchResult.title
                ))
            })
        ))
    }
}

//
//  SearchInteractor.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import Foundation

actor SearchInteractor: SearchInteractable {
    
    private let output: any SearchInteractorOutput
    private let actions: SearchActions
    private var state: SearchState
    
    @Dependency(\.getUserWorker) private var getUserWorker
    @Dependency(\.searchWorker) private var searchWorker
    
    init(output: any SearchInteractorOutput, actions: SearchActions, state: SearchState) {
        self.output = output
        self.actions = actions
        self.state = state
    }
}

// MARK: - SearchInteractable
extension SearchInteractor {
    
    func load(initialize request: SearchLogic.Initialize.Request) async {
        guard !state.isLoading else { return }
        
        state.isLoading = true
        await output.present(loading: SearchLogic.Loading.Response(isLoading: state.isLoading))
        
        do {
            let user = try await getUserWorker.invoke()
            state.user = user
            await output.present(initalize: SearchLogic.Initialize.Response(user: user))
        } catch {
            state.retryAction = { [weak self] in
                Task { [weak self] in
                    await self?.load(initialize: SearchLogic.Initialize.Request())
                }
            }
            await output.present(error: SearchLogic.Error.Response())
        }
        
        await output.present(loading: SearchLogic.Loading.Response(isLoading: false))
        state.isLoading = false
    }
    
    func load(retry request: SearchLogic.Retry.Request) async {
        state.retryAction?()
        state.retryAction = nil
    }
    
    func load(search request: SearchLogic.Search.Request) async {
        guard !state.isLoading else { return }
        
        state.searchText = request.searchText
        state.searchOffset = 0
        state.isLoading = true
        await output.present(loading: SearchLogic.Loading.Response(isLoading: state.isLoading))
        
        do {
            let searchResults = try await searchWorker.invoke(with: request.searchText, offset: state.searchOffset, limit: state.searchLimit)
            state.set(searchResults: searchResults)
            await output.present(search: SearchLogic.Search.Response(searchResults: searchResults))
        } catch {
            state.retryAction = { [weak self] in
                Task { [weak self] in
                    await self?.load(search: request)
                }
            }
            await output.present(error: SearchLogic.Error.Response())
        }
        
        await output.present(loading: SearchLogic.Loading.Response(isLoading: false))
        state.isLoading = false
    }
    
    func load(detail request: SearchLogic.Detail.Request) async {
        guard let searchResult = state.searchResults.first(where: { $0.id == request.id }) else {
            return assertionFailure("Received an id which isn't stored, implementation issue?")
        }
        
        actions.onDidTapSearchResult(searchResult)
    }
    
    func load(searchPagination request: SearchLogic.SearchPagination.Request) async {
        guard !state.isLoading && !state.searchEndReached else { return }
        
        state.isLoading = true
        await output.present(loading: SearchLogic.Loading.Response(isLoading: state.isLoading))
        
        do {
            let searchResults = try await searchWorker.invoke(with: state.searchText, offset: state.searchOffset, limit: state.searchLimit)
            state.set(searchResults: searchResults)
            await output.present(searchPagination: SearchLogic.SearchPagination.Response(searchResults: searchResults))
        } catch {
            state.retryAction = { [weak self] in
                Task { [weak self] in
                    await self?.load(searchPagination: request)
                }
            }
            await output.present(error: SearchLogic.Error.Response())
        }
        
        await output.present(loading: SearchLogic.Loading.Response(isLoading: false))
        state.isLoading = false
    }
}

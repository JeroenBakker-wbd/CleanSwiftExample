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
        
        state.isLoading = false
        await output.present(loading: SearchLogic.Loading.Response(isLoading: state.isLoading))
    }
    
    func load(retry request: SearchLogic.Retry.Request) async {
        state.retryAction?()
        state.retryAction = nil
    }
    
    func load(search request: SearchLogic.Search.Request) async {
        guard !state.isLoading else { return }
        
        state.isLoading = true
    }
}

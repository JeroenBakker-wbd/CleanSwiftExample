//
//  SearchProtocols.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import Foundation

protocol SearchInteractable {
    func load(initialize request: SearchLogic.Initialize.Request) async
    func load(retry request: SearchLogic.Retry.Request) async
    func load(search request: SearchLogic.Search.Request) async
}

protocol SearchPresentable {
    func present(initalize response: SearchLogic.Initialize.Response) async
    func present(loading response: SearchLogic.Loading.Response) async
    func present(error response: SearchLogic.Error.Response) async
    func present(search response: SearchLogic.Search.Response) async
}

protocol SearchViewable: AnyObject {
    func show(initalize viewModel: SearchLogic.Initialize.ViewModel) async
    func show(loading viewModel: SearchLogic.Loading.ViewModel) async
    func show(error viewModel: SearchLogic.Error.ViewModel) async
    func show(search viewModel: SearchLogic.Search.ViewModel) async
}

typealias SearchInteractorInput = SearchViewOutput
typealias SearchPresenterInput = SearchInteractorOutput
typealias SearchViewInput = SearchPresenterOutput

typealias SearchInteractorOutput = SearchPresentable
typealias SearchPresenterOutput = SearchViewable
typealias SearchViewOutput = SearchInteractable

//
//  SearchView.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 17/04/2023.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var viewModel: SearchViewModel
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                Text(viewModel.title)
                List {
                    ForEach(viewModel.searchDataSourceItem, id: \.hashValue) { searchDataSourceItem in
                        switch searchDataSourceItem {
                        case .results(let itemViewModel):
                            Button(action: {
                                Task { await viewModel.output?.load(detail: .init(id: itemViewModel.id)) }
                            }) {
                                Text(itemViewModel.title).onAppear {
                                    checkIfScrolledToLastItem(encounteredItem: searchDataSourceItem)
                                }
                            }
                        }
                    }
                }
                if let retryTitle = viewModel.retryButtonTitle {
                    Button(retryTitle) {
                        Task { await viewModel.output?.load(retry: .init()) }
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .onSubmit(of: .search, {
            Task { await viewModel.output?.load(search: .init(searchText: searchText)) }
        })
        .onChange(of: searchText, perform: { _ in
            Task { await viewModel.output?.load(search: .init(searchText: searchText)) }
        })
        .task {
            await viewModel.output?.load(initialize: .init())
        }
    }
    
    private func checkIfScrolledToLastItem(encounteredItem: SearchDataSourceItem) {
        guard encounteredItem == viewModel.searchDataSourceItem.last else { return }
        
        Task { await viewModel.output?.load(searchPagination: .init()) }
    }
}

#if DEBUG
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let viewModel = SearchViewModel()
            SearchView(viewModel: viewModel)
                .task {
                    await viewModel.show(initalize: SearchLogic.Initialize.ViewModel(greeting: "Hello user"))
                }
            
            SearchView(viewModel: viewModel)
                .task {
                    await viewModel.show(search: SearchLogic.Search.ViewModel(searchDataSourceItem: [
                        .results(SearchTitleCell.ViewModel(id: "1", title: "Hey first result")),
                        .results(SearchTitleCell.ViewModel(id: "2", title: "Hey second result")),
                        .results(SearchTitleCell.ViewModel(id: "3", title: "Hey third result")),
                        .results(SearchTitleCell.ViewModel(id: "4", title: "Hey fourth result"))
                    ]))
                }
            
            SearchView(viewModel: viewModel)
                .task {
                    await viewModel.show(error: SearchLogic.Error.ViewModel(title: "Somethign went wrong", ctaTitle: "Try again"))
                }
            
            SearchView(viewModel: viewModel)
                .task {
                    await viewModel.show(loading: SearchLogic.Loading.ViewModel(showSpinner: true))
                }
        }
    }
}
#endif

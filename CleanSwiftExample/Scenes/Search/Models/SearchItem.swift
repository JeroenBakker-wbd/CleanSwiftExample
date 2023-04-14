//
//  SearchItem.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import Foundation

enum SearchDataSourceItem {
    case results(SearchTitleCell.ViewModel)
    
    var reuseIdentifier: String {
        switch self {
        case .results:
            return SearchTitleCell.reuseIdentifier
        }
    }
}

// MARK: - Hashable
extension SearchDataSourceItem: Hashable {
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .results(let viewModel):
            hasher.combine(viewModel.uniqueId)
        }
    }
}

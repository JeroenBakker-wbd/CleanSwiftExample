//
//  SearchState.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import Foundation

struct SearchState {
    var isLoading: Bool = false
    var user: User? = nil
    
    var searchText: String = ""
    var searchResults: [SearchResults] = []
    var searchOffset: Int = 0
    var searchLimit: Int = 20
    var searchEndReached: Bool = false
    
    var retryAction: (@Sendable () -> Void)? = nil
    
    mutating func set(searchResults: [SearchResults]) {
        self.searchResults = searchResults
        
        searchOffset = searchResults.count
        searchEndReached = searchResults.count < searchLimit
    }
    
    mutating func append(searchResults: [SearchResults]) {
        self.searchResults.append(contentsOf: searchResults)
        
        searchOffset = self.searchResults.count
        searchEndReached = searchResults.count < searchLimit
    }
}

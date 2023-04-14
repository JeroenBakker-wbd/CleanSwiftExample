//
//  SearchWorker.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import Foundation

struct SearchResults: Equatable {
    let id: String
    let title: String
}

protocol SearchWorkerable {
    func invoke(with searchTerm: String, offset: Int, limit: Int) async throws -> [SearchResults]
}

struct SearchWorker: SearchWorkerable {
    
    func invoke(with searchTerm: String, offset: Int, limit: Int) async throws -> [SearchResults] {
        try await Task.sleep(for: .seconds(2))
        
        return [
            SearchResults(id: "1", title: "Hey first result"),
            SearchResults(id: "2", title: "Hey second result"),
            SearchResults(id: "3", title: "Hey third result"),
            SearchResults(id: "4", title: "Hey fourth result"),
            SearchResults(id: "5", title: "Hey fifth result")
        ]
    }
}

//
//  SearchWorker.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import Foundation

struct SearchResults: Equatable {
    let id: String
}

protocol SearchWorkerable {
    func invoke(with searchTerm: String, offset: Int, limit: Int) async throws -> [SearchResults]
}

struct SearchWorker: SearchWorkerable {
    
    func invoke(with searchTerm: String, offset: Int, limit: Int) async throws -> [SearchResults] {
        try await Task.sleep(for: .seconds(2))
        
        return [
            SearchResults(id: "1"),
            SearchResults(id: "2"),
            SearchResults(id: "3"),
            SearchResults(id: "4"),
            SearchResults(id: "5")
        ]
    }
}

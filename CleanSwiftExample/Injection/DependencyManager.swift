//
//  DependencyManager.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import Factory

typealias DependencyManager = Factory
typealias Dependency = Injected
typealias DependencyContainer = Container

// MARK: - Workers
extension DependencyContainer {
    
    var getUserWorker: DependencyManager<GetUserWorkerable> {
        self { GetUserWorker() }
    }
    
    var searchWorker: DependencyManager<SearchWorkerable> {
        self { SearchWorker() }
    }
}

// MARK: - Mappers
extension DependencyContainer {
    
    var localisationMapper: DependencyManager<LocalisationMapperable> {
        self { LocalisationMapper() }
    }
}

//
//  GetUserWorker.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import Foundation
import StarWarsAPI

struct User: Equatable {
    let firstName: String
    let lastName: String
}

protocol GetUserWorkerable {
    func invoke() async throws -> User
}

struct GetUserWorker: GetUserWorkerable {
    
    @Dependency(\.apiWorker) private var apiWorker
    
    func invoke() async throws -> User {
        let data = try await apiWorker.fetch(query: PersonNameQuery(personId: "1"))
        
        return User(firstName: data.person?.name ?? "Unknown", lastName: "Swift")
    }
}

//
//  GetUserWorker.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import Foundation

struct User: Equatable {
    let firstName: String
    let lastName: String
}

protocol GetUserWorkerable {
    func invoke() async throws -> User
}

struct GetUserWorker: GetUserWorkerable {
    
    func invoke() async throws -> User {
        try await Task.sleep(for: .seconds(2))
        return User(firstName: "Clean", lastName: "Swift")
    }
}

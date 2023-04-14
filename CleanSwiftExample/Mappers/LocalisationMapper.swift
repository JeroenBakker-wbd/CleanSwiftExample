//
//  LocalisationMapper.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import Foundation

enum LocalisationKey {
    case searchGreeting(firstName: String)
    case searchGetUserError
    case searchGetUserCTATitle
}

protocol LocalisationMapperable {
    func map(key: LocalisationKey) -> String
}

struct LocalisationMapper: LocalisationMapperable {
    
    // TODO: - Use LS file
    func map(key: LocalisationKey) -> String {
        switch key {
        case .searchGreeting(let firstName):
            return "Greetings \(firstName)"
        case .searchGetUserError:
            return "An error occured fetching you!"
        case .searchGetUserCTATitle:
            return "Try again"
        }
    }
}

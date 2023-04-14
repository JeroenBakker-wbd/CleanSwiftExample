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
    var retryAction: (() -> Void)? = nil
}

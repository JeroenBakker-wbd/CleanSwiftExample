//
//  SearchLogic.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import Foundation

enum SearchLogic {
    
    enum Initialize {
        struct Request { }
        
        struct Response {
            let user: User
        }
        
        struct ViewModel {
            let greeting: String
        }
    }
    
    enum Loading {
        struct Response {
            let isLoading: Bool
        }
        
        struct ViewModel {
            let showSpinner: Bool
        }
    }
    
    enum Error {
        struct Response { }
        
        struct ViewModel {
            let title: String
            let ctaTitle: String
        }
    }
    
    enum Retry {
        struct Request { }
    }
    
    enum Search {
        struct Request {
            let searchText: String
        }
        
        struct Response { }
        
        struct ViewModel { }
    }
}

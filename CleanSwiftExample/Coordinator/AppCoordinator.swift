//
//  AppCoordinator.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import UIKit

final class AppCoordinator: UINavigationController {
    
    required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("storyboard not supported")
    }
    
    func start() {
        let searchActions = SearchActions {
            print("Did finish search!")
        }
        
        let search = SearchAssembly().build(with: .default, actions: searchActions)
        setViewControllers([search], animated: false)
    }
}

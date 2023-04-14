//
//  SearchAssembly.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import UIKit

struct SearchAssembly: Assembling {

    func build(with sceneModel: SearchEntry, actions: SearchActions) -> UIViewController {
        let controller = SearchViewController()
        
        let state = SearchState()
        let presenter = SearchPresenter(output: controller)
        
        let interactor = SearchInteractor(output: presenter, actions: actions, state: state)

        controller.output = interactor
        
        return controller
    }
}

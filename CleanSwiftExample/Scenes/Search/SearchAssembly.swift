//
//  SearchAssembly.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import UIKit
import SwiftUI

struct SearchAssembly: Assembling {
    
    private let useSwiftUI: Bool = true // debug flag, for showing swiftui implementation purpose

    func build(with sceneModel: SearchEntry, actions: SearchActions) -> UIViewController {
        if useSwiftUI {
            let viewModel = SearchViewModel()
            let view = SearchView(viewModel: viewModel)
            
            let state = SearchState()
            let presenter = SearchPresenter(output: viewModel)
            
            let interactor = SearchInteractor(output: presenter, actions: actions, state: state)
            
            viewModel.output = interactor
            
            return UIHostingController(rootView: view)
        } else {
            let controller = SearchViewController()
            
            let state = SearchState()
            let presenter = SearchPresenter(output: controller)
            
            let interactor = SearchInteractor(output: presenter, actions: actions, state: state)
            
            controller.output = interactor
            
            return controller
        }
    }
}

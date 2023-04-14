//
//  Assembling.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 14/04/2023.
//

import UIKit

public protocol Assembling {
    associatedtype Model
    associatedtype Actions

    func build(with: Self.Model, actions: Self.Actions) -> UIViewController
}

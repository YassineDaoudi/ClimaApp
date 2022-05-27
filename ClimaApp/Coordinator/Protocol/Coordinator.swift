//
//  Coordinator.swift
//  ClimaApp
//
//  Created by Yassine DAOUDI on 26/5/2022.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

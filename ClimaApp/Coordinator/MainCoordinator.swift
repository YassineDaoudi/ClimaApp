//
//  MainCoordinator.swift
//  ClimaApp
//
//  Created by Yassine DAOUDI on 26/5/2022.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = WeatherViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showList() {
        let vc = WeatherCVL()
        vc.coordinator = self
        vc.title = "Cities"
        let navigation = UINavigationController(rootViewController: vc)
        navigationController.present(navigation, animated: true)
    }
}

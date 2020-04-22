//
//  MainTabCoordinator.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/08.
//

import UIKit

final class MainTabCoordinator: TabBarCoordinator {
    let tabBarController: UITabBarController
    private let childCoordinators: [Coordinator]

    init(presenter: UITabBarController = TabBarViewController(), childCoordinators: [Coordinator]) {
        self.tabBarController = presenter
        self.childCoordinators = childCoordinators
    }

    func start() {
        childCoordinators.forEach { coordinator in
            coordinator.start()
        }
        tabBarController.setViewControllers(
            childCoordinators.map { $0.presenter },
            animated: false
        )
    }
}

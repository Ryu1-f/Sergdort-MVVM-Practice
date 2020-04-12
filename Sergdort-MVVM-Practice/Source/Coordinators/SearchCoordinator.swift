//
//  SearchCoordinator.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/12.
//

import UIKit

final class SearchCoordinator: NavigationCoordinator {
    let navigationController: UINavigationController

    init(presenter: UINavigationController) {
        self.navigationController = presenter
    }

    func start() {
        let viewController: SearchViewController = .init()
        navigationController.viewControllers = [viewController]
        navigationController.tabBarItem = .init(tabBarSystemItem: .search, tag: 1)
    }
}

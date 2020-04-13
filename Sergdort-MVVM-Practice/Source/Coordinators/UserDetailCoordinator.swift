//
//  UserDetailCoordinator.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/13.
//

import UIKit

final class UserDetailCoordinator: NavigationCoordinator {
    let navigationController: UINavigationController
    let title: String

    init(presenter: UINavigationController, title: String) {
        self.navigationController = presenter
        self.title = title
    }

    func start() {
        let viewController: UserDetailViewController = .init()
        viewController.title = title
        navigationController.pushViewController(viewController, animated: true)
    }
}

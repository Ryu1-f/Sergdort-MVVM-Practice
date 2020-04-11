//
//  UserSearchCoordinator.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/09.
//

import Foundation
import UIKit

final class UserSearchCoordinator: NavigationCoordinator, DetailsPresentable {
    var navigationController: UINavigationController

    init(presenter: UINavigationController) {
        self.navigationController = presenter
        presenter.title = "Search"
    }

    func start() {
        let userSearchViewController: UserSearchViewController = UserSearchViewController()
        navigationController.pushViewController(userSearchViewController, animated: false)
    }
}

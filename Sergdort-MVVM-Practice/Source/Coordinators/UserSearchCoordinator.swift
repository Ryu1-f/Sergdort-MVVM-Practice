//
//  UserSearchCoordinator.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/09.
//

import Foundation
import UIKit

final class UserSearchCoordinator: Coordinator {
    private let navigationController: UINavigationController
    //    private var userSearchViewController: UserSearchViewController

    init(presenter: UINavigationController) {
        self.navigationController = presenter
        presenter.title = "Search"
    }

    func start() {
        let userSearchViewController: UserSearchViewController = UserSearchViewController()
        navigationController.pushViewController(userSearchViewController, animated: false)
    }
}

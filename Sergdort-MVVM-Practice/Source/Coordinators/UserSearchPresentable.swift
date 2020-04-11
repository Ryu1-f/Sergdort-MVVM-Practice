//
//  UserSearchPresentable.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/08.
//

import Foundation
import UIKit

protocol DetailsPresentable {
    func showUserDetail(item: Users.Item)
}

extension DetailsPresentable where Self: NavigationCoordinator {
    func showUserDetail(item: Users.Item) {
        let userDetailViewController: UserDetailViewController = UserDetailViewController()
        userDetailViewController.title = item.login
        navigationController.pushViewController(userDetailViewController, animated: true)
    }
}

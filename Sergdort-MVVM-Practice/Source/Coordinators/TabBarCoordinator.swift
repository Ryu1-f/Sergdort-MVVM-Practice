//
//  TabBarCoordinator.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/08.
//

import UIKit

protocol TabBarCoordinator {
    var tabBarController: UITabBarController { get }
}

extension TabBarCoordinator {
    var presenter: UIViewController {
        tabBarController as UIViewController
    }
}

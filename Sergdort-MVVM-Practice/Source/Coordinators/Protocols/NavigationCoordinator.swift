//
//  NavigationCoordinator.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/08.
//

import UIKit

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get }
}

extension NavigationCoordinator {
    var presenter: UIViewController {
        navigationController as UIViewController
    }
}

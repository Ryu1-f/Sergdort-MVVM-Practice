//
//  AppCoordinator.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/08.
//
import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let rootViewController: UITabBarController
    private var userSearchCoordinator: UserSearchCoordinator

    init(window: UIWindow) {
        self.window = window
        self.rootViewController = .init()

        let userSearchNavigationController: UINavigationController = .init()
        self.userSearchCoordinator = .init(presenter: userSearchNavigationController)
        rootViewController.viewControllers = [userSearchNavigationController]
    }

    func start() {
        window.rootViewController = rootViewController
        userSearchCoordinator.start()
        window.makeKeyAndVisible()
    }
}

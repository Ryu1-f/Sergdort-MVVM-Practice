//
//  AppCoordinator.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/08.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let rootViewController: Coordinator

    init(window: UIWindow, rootViewController: Coordinator) {
        self.window = window
        self.rootViewController = rootViewController
    }

    func start() {
        rootViewController.start()
        window.rootViewController = rootViewController.presenter
        window.makeKeyAndVisible()
    }
}

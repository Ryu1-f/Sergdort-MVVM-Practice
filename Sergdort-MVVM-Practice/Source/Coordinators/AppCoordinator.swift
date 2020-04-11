//
//  AppCoordinator.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/08.
//
import UIKit

final class AppCoordinators {
    private let window: UIWindow
    private let rootCoordinator: Coordinator

    init(window: UIWindow, rootCoordinator: Coordinator) {
        self.window = window
        self.rootCoordinator = rootCoordinator
    }

    func start() {
        rootCoordinator.start()
        window.rootViewController = rootCoordinator.presenter
        window.makeKeyAndVisible()
    }
}

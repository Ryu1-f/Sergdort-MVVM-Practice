//
//  TabBarViewController.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let currentIndex = tabBarController.selectedIndex
        guard let nextIndex = tabBarController.viewControllers?.lastIndex(of: toVC) else { return nil }
        let direction: TabAnimator.Direction = currentIndex > nextIndex ? .right : .left
        return TabAnimator(scrollDirection: direction)
    }
}

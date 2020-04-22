//
//  NavigationController.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/22.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let direction: NavigationAnimator.Direction = operation == .push ? .left : .right
        return NavigationAnimator(scrollDirection: direction)
    }
}

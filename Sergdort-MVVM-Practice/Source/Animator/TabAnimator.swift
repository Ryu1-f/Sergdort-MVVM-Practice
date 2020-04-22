//
//  TabBarController.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/22.
//

import UIKit

private enum Const {
    public static let duration: Double = 0.4
    public static let moveWidth: CGFloat = 25
}

class TabAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum Direction {
        case right
        case left
    }

    private let scrollDirection: Direction

    public init(scrollDirection: Direction) {
        self.scrollDirection = scrollDirection
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        Const.duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: .from),
            let to = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
        }

        from.view.alpha = 1
        to.view.alpha = .zero
        to.view.transform = CGAffineTransform(
            translationX: scrollDirection == .left ? Const.moveWidth : -Const.moveWidth,
            y: .zero
        )
        transitionContext.containerView.addSubview(to.view)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                        from.view.alpha = .zero
                        to.view.alpha = 1
                        to.view.transform = .identity
        }) { didComplete in
            from.view.alpha = 1
            transitionContext.completeTransition(didComplete)
        }
    }
}

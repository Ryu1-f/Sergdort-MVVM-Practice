//
//  UIImage+UIColor.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/02.
//

import UIKit

public extension UIView {
    /// `hitTest(_:with:)` ignores view objects that are hidden, that have disabled user interactions,
    /// or have an alpha level less than 0.01.
    /// - SeeAlso: https://developer.apple.com/documentation/uikit/uiview/1622469-hittest
    var hitTestable: Bool {
        alpha >= 0.01 && !isHidden && isUserInteractionEnabled
    }

    var allSubviews: [UIView] {
        subviews.reduce([]) { $0 + [$1] + $1.allSubviews }
    }

    func addedTapGesture() -> UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer()
        addGestureRecognizer(gesture)
        return gesture
    }

    func addedPanGesture() -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer()
        addGestureRecognizer(gesture)
        return gesture
    }

    func addedPinchGesture() -> UIPinchGestureRecognizer {
        let gesture = UIPinchGestureRecognizer()
        addGestureRecognizer(gesture)
        return gesture
    }

    func addedLongPressGesture() -> UILongPressGestureRecognizer {
        let gesture = UILongPressGestureRecognizer()
        addGestureRecognizer(gesture)
        return gesture
    }

    func semicircularize() {
        clipsToBounds = true
        layer.cornerRadius = bounds.height / 2
    }

    var frameWithoutSafeArea: CGRect {
        frame.inset(by: safeAreaInsets)
    }

    var boundsWithoutSafeArea: CGRect {
        bounds.inset(by: safeAreaInsets)
    }

    func convertedFrame(to view: UIView?) -> CGRect {
        convert(boundsWithoutSafeArea, to: view)
    }
}

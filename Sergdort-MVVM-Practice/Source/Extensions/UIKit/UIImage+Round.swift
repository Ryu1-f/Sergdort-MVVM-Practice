//
//  UIImage+Round.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/01.
//

import UIKit

public extension UIImage {
    func rounded(to radius: CGFloat) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            let rect = CGRect(origin: .zero, size: size)

            UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
            draw(in: rect)
        }
    }
}

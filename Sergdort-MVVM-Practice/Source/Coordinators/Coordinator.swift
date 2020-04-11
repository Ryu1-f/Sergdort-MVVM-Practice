//
//  Coordinator.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/08.
//

import UIKit

protocol Coordinator {
    var presenter: UIViewController { get }
    func start()
}

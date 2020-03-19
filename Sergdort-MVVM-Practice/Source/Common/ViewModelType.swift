//
//  ViewModelType.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/03/19.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

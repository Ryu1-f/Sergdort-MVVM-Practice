//
//  materialized+elements.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/03/21.
//

import Foundation
import RxSwift

extension RxSwift.ObservableType where Element: RxSwift.EventConvertible {

    public func elements() -> RxSwift.Observable<Element.Element> {
        return filter { $0.event.element != nil }
            .map { $0.event.element! }
    }

    public func errors() -> RxSwift.Observable<Swift.Error> {
        return filter { $0.event.error != nil }
            .map { $0.event.error! }
    }
}

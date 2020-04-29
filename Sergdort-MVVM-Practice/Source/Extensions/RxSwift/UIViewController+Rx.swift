//
//  UIViewController+Rx.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/27.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIViewController {
    public var viewDidLoad: Observable<Void> {
        return methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
    }

    public var viewWillAppear: Observable<Bool> {
        return methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
    }

    public var viewDidAppear: Observable<Bool> {
        return methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
    }

    public var viewWillDisappear: Observable<Bool> {
        return methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
    }

    public var viewDidDisappear: Observable<Bool> {
        return methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
    }

    public var isDismissing: Observable<Bool> {
        return sentMessage(#selector(Base.dismiss)).map { $0.first as? Bool ?? false }
    }

    public var isVisible: Observable<Bool> {
        return Observable.merge(
            base.rx.viewDidAppear.map { _ in true },
            base.rx.viewDidDisappear.map { _ in false }
        )
    }
}

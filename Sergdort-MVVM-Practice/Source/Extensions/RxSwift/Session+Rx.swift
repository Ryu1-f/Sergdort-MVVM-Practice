//
//  Session+Rx.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/05.
//

import RxSwift
import APIKit

extension Session: ReactiveCompatible {
}

public extension Reactive where Base: Session {
    func response<T: Request>(_ request: T) -> Single<T.Response> {
        Single<T.Response>.create { [weak base] single in
            let task = base?.send(request) { result in
                switch result {
                case .success(let response):
                    single(.success(response))
                    print(response)
                case .failure(let error):
                    single(.error(error))
                    print(error)
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}

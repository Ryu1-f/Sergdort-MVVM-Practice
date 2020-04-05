//
//  SearchRepository.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/05.
//

import Foundation
import RxSwift
import APIKit

protocol SearchRepositoryProtocol: AnyObject {
    func getUsers(name: String) -> Single<Users>
}

public final class SearchRepository: SearchRepositoryProtocol {
    private let session: Session

    init(session: Session = .shared) {
        self.session = session
    }

    public func getUsers(name: String) -> Single<Users> {
        let request = SearchService.GetUsers(with: name)
        return session.rx.response(request)
    }
}

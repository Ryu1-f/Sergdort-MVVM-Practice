//
//  WikipediaSearchRepositoryStub.swift
//  Sergdort-MVVM-PracticeTests
//
//  Created by 深見龍一 on 2020/03/22.
//

import Foundation
import RxSwift
@testable import Sergdort_MVVM_Practice

public class WikipediaSearchRepositoryStub: WikipediaSearchProtocol {
    public var search: Single<[WikipediaPage]>

    public func search(from word: String) -> Single<[WikipediaPage]> {
        return search
    }

    public init(search: Single<[WikipediaPage]>) {
        self.search = search
    }
}

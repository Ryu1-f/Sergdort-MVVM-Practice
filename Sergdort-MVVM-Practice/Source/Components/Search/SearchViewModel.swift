//
//  SearchViewModel.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/03/19.
//

import RxSwift
import RxCocoa

class SearchViewModel {
    struct Dependency {
        var wikipediaAPI: WikipediaAPI
        var scheduler: SchedulerType

        public static var `default`: Dependency {
            Dependency(
                wikipediaAPI: WikipediaDefaultAPI(URLSession: .shared),
                scheduler: ConcurrentMainScheduler.instance
            )
        }
    }
    

    private let dependency: Dependency
    private let disposeBag = DisposeBag()

    init(dependency: Dependency = .default) {
        self.dependency = dependency
    }
}

extension SearchViewModel {
    struct Input {
        let searchText: Observable<String>
    }

    struct Output {
      let wikipediaPages: Observable<[WikipediaPage]>
      let searchDescription: Observable<String>
      let error: Observable<Error>
    }

    func transform(input: Input) -> Output {
        let filterdText = input.searchText
            .debounce(.milliseconds(300), scheduler: dependency.scheduler)
            .share(replay: 1)

        let sequence = filterdText
            .flatMapLatest { [weak self] text -> Observable<Event<[WikipediaPage]>> in
                return (self?.dependency.wikipediaAPI
                    .search(from: text)
                    .materialize())!
            }
            .share(replay: 1)

        let wikipediaPages = sequence.elements()

        let _searchDescription = PublishRelay<String>()

        wikipediaPages
            .withLatestFrom(filterdText) { (pages, word) -> String in
                print(pages)
              return "\(word) \(pages.count)件"
            }
            .bind(to: _searchDescription)
            .disposed(by: disposeBag)

        return Output(wikipediaPages: wikipediaPages,
                    searchDescription: _searchDescription.asObservable(),
                    error: sequence.errors())
    }
}

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

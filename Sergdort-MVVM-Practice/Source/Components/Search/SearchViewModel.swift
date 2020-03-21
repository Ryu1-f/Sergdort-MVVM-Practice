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
        var wikipediaAPI: WikipediaSearchProtocol
        var scheduler: SchedulerType

        public static var `default`: Dependency {
            Dependency(
                wikipediaAPI: WikipediaSearch(urlSession: .shared),
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
        let isLoading: Observable<Bool>
    }

    func transform(input: Input) -> Output {
        let _wikipediaPages = PublishSubject<[WikipediaPage]>()
        let _searchDescription = PublishSubject<String>()
        let _error = PublishSubject<Error>()
        let _isLoading = PublishSubject<Bool>()

        let filterdText = input.searchText
            .debounce(.milliseconds(300), scheduler: dependency.scheduler)
            .share(replay: 1)

        let sequence = filterdText
            .do(onNext: { _ in
                _isLoading.onNext(true)
            })
            .flatMap { [weak self] text -> Observable<Event<[WikipediaPage]>> in
                if text == "" { return Observable.from([]).materialize() }
                return (self?.dependency.wikipediaAPI.search(from: text))!
                    .asObservable()
                    .materialize()
            }
            .do(onNext: { _ in
                _isLoading.onNext(false)
            })
            .share(replay: 1)

        sequence
            .errors()
            .bind(to: _error)
            .disposed(by: disposeBag)

        sequence
            .elements()
            .bind(to: _wikipediaPages)
            .disposed(by: disposeBag)

        _wikipediaPages
            .withLatestFrom(filterdText) { (pages, word) -> String in
                "\(word) \(pages.count)件"
            }
            .bind(to: _searchDescription)
            .disposed(by: disposeBag)

        return Output(wikipediaPages: _wikipediaPages,
                    searchDescription: _searchDescription,
                    error: _error,
                    isLoading: _isLoading
        )
    }
}

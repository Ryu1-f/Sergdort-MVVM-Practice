//
//  SearchViewModel2.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/05.
//

import Foundation
import RxSwift
import RxCocoa

class UserSearchViewModel {
    struct Dependency {
        var searchRepository: SearchRepository
        var scheduler: SchedulerType

        public static var `default`: Dependency {
            Dependency(
                searchRepository: SearchRepository(),
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

extension UserSearchViewModel {
    struct Input {
        let searchText: Observable<String>
    }

    struct Output {
        let searchDescription: Observable<String>
        let usersItem: Observable<[Users.Item]>
        let error: Observable<Error>
        let isLoading: Observable<Bool>
    }

    func transform(input: Input) -> Output {
        let _users = PublishRelay<Users>()
        let _usersItem = PublishRelay<[Users.Item]>()
        let _searchDescription = PublishRelay<String>()
        let _isLoading = PublishRelay<Bool>()

        let filterdText = input.searchText
            .debounce(.milliseconds(300), scheduler: dependency.scheduler)
            .share(replay: 1)

        let sequence = filterdText
            .do(onNext: { _ in
                _isLoading.accept(true)
            })
            .flatMap { [weak self] text -> Observable<Event<Users>> in
                if text == "" { return Observable.from([]).materialize() }
                return (self?.dependency.searchRepository.getUsers(name: text))!
                    .asObservable()
                    .materialize()
        }
        .do(onNext: { _ in
            _isLoading.accept(false)
        })
            .share(replay: 1)

        sequence
            .elements()
            .bind(to: _users)
            .disposed(by: disposeBag)

        _users
            .withLatestFrom(filterdText) { (pages, word) -> String in
                print(pages.total_count)
                return "\(word) \(pages.total_count)件"
        }
        .bind(to: _searchDescription)
        .disposed(by: disposeBag)

        _users
            .map { $0.items }
            .bind(to: _usersItem)
            .disposed(by: disposeBag)

        return Output(searchDescription: _searchDescription.asObservable(),
                      usersItem: _usersItem.asObservable(),
                      error: sequence.errors(),
                      isLoading: _isLoading.asObservable()
        )
    }
}

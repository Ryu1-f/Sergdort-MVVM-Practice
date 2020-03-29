//
//  Sergdort_MVVM_PracticeTests.swift
//  Sergdort-MVVM-PracticeTests
//
//  Created by 深見龍一 on 2020/03/22.
//

import Foundation
import RxSwift
import RxTest
import RxBlocking
import Quick
import Nimble
@testable import Sergdort_MVVM_Practice

class SearchViewModelSpec: QuickSpec {
    private let disposeBag: DisposeBag = DisposeBag()
    private let decoder: JSONDecoder = JSONDecoder()

    override func spec() {
        var wikipediaSearchRepositoryStub: WikipediaSearchRepositoryStub!
        var scheduler: TestScheduler!
        var viewModel: SearchViewModel!
        var input: SearchViewModel.Input!
        var output: SearchViewModel.Output!

        describe("call API") {
            context("when result successed") {

                var inputTextObservable: Array<Recorded<Event<String>>>!
                var searchText: TestableObservable<String>!

                var pagesObserver: TestableObserver<[WikipediaPage]>!
                var resultDescriptionObserver: TestableObserver<String>!

                let mockPage1 = try! decoder.decode(
                        WikipediaPage.self,
                        from: "{\"pageid\": 1, \"title\": \"TAYLOR SWIFT\"}".data(using: .utf8)!
                )

                let mockPage2 = try! decoder.decode(
                        WikipediaPage.self,
                        from: "{\"pageid\": 2, \"title\": \"TAYLOR SWIFT2\"}".data(using: .utf8)!
                )

                wikipediaSearchRepositoryStub = .init(search: Observable.of([mockPage1, mockPage2]).asSingle())
                beforeEach {
                    scheduler = TestScheduler(initialClock: 0, resolution: 0.1)
                    viewModel = .init(
                        dependency: .init(
                            wikipediaAPI: wikipediaSearchRepositoryStub,
                            scheduler: scheduler
                        )
                    )

                    pagesObserver = scheduler.createObserver([WikipediaPage].self)
                    resultDescriptionObserver = scheduler.createObserver(String.self)
                }

                context("when debounce time passed") {
                    beforeEach {
                        inputTextObservable = [
                            Recorded.next(1, "Ryu"),
                            Recorded.next(5, "Ryu1")
                        ]
                        searchText = scheduler.createHotObservable(inputTextObservable)

                        input = .init(searchText: searchText.asObservable())
                        output = viewModel.transform(input: input)

                        output.wikipediaPages
                            .bind(to: pagesObserver)
                            .disposed(by: self.disposeBag)

                        output.searchDescription
                            .bind(to: resultDescriptionObserver)
                            .disposed(by: self.disposeBag)

                        scheduler.start()
                    }

                    it("get mock data at 4, 8 sec") {
                        expect(pagesObserver.events).to(equal([
                            Recorded.next(4, [mockPage1, mockPage2]),
                            Recorded.next(8, [mockPage1, mockPage2])
                        ]))
                    }

                    it("get result description at 8 sec") {
                        expect(resultDescriptionObserver.events).to(equal([
                            Recorded.next(8, "Ryu 2件")
                        ]))
                    }
                }

                context("when debounce time not passed") {
                    beforeEach {
                        inputTextObservable = [
                            Recorded.next(1, "R"),
                            Recorded.next(4, "Ryu"),
                            Recorded.next(7, "Ryu1")
                        ]
                        searchText = scheduler.createHotObservable(inputTextObservable)

                        input = .init(searchText: searchText.asObservable())
                        output = viewModel.transform(input: input)

                        output.wikipediaPages
                            .bind(to: pagesObserver)
                            .disposed(by: self.disposeBag)

                        output.searchDescription
                            .bind(to: resultDescriptionObserver)
                            .disposed(by: self.disposeBag)

                        scheduler.start()
                    }

                    it("get mock data at 10 sec") {
                        expect(pagesObserver.events).to(equal([
                            Recorded.next(10, [mockPage1, mockPage2])
                        ]))
                    }

                    it("get empty result description") {
                        expect(resultDescriptionObserver.events).to(equal([]))
                    }
                }

                context("when search text is empty") {
                    beforeEach {
                        input = .init(searchText: Observable.just(""))
                        output = viewModel.transform(input: input)

                        output.wikipediaPages
                            .bind(to: pagesObserver)
                            .disposed(by: self.disposeBag)
                    }

                    it("get mock data at 10 sec") {
                        expect(pagesObserver.events).to(equal([]))
                    }
                }
            }

            context("when result failed") {
                var error: Error!
                scheduler = TestScheduler(initialClock: 0, resolution: 0.1)
                enum TestError: Error {
                    case testError
                }

                beforeEach {
                    let errorResult: Single<[WikipediaPage]> = Observable<[WikipediaPage]>.error(TestError.testError).asSingle()
                    wikipediaSearchRepositoryStub = .init(search: errorResult)

                    viewModel = .init(
                        dependency: .init(
                            wikipediaAPI: wikipediaSearchRepositoryStub,
                            scheduler: scheduler
                        )
                    )

                    input = .init(searchText: Observable.just("error"))
                    output = viewModel.transform(input: input)

                    error = try! output.error.toBlocking().first()!
                }

                it("can get correct error") {
                    expect(error as? TestError).to(equal(TestError.testError))
                }
            }
        }
    }
}

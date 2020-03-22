//
//  Sergdort_MVVM_PracticeTests.swift
//  Sergdort-MVVM-PracticeTests
//
//  Created by 深見龍一 on 2020/03/22.
//

import Foundation
import RxSwift
import RxTest
import Quick
import Nimble
@testable import Sergdort_MVVM_Practice

class Sergdort_MVVM_PracticeTests: QuickSpec {
    private let disposeBag: DisposeBag = DisposeBag()

    override func spec() {
        var wikipediaSearchRepositoryStub: WikipediaSearchRepositoryStub!
        describe("何をテストするか") {
            context("フィルター境界線ギリギリのテストをする") {
                let scheduler = TestScheduler(initialClock: 0, resolution: 0.1)

                let mockPage1 = try! JSONDecoder().decode(
                    WikipediaPage.self,
                    from: "{\"pageid\": 1, \"title\": \"TAYLOR SWIFT\"{".data(using: .utf8)!
                    )

                let mockPage2 = try! JSONDecoder().decode(
                    WikipediaPage.self,
                    from: "{\"pageid\": 2, \"title\": \"TAYLOR SWIFT2\"{".data(using: .utf8)!
                    )

                let inputTextObservable = [
                    Recorded.next(1, "R"),
                    Recorded.next(2, "Ryu"),
                    Recorded.next(6, "Ryu1")
                ]

                wikipediaSearchRepositoryStub = .init(search: Observable.of([mockPage1, mockPage2]).asSingle())
                it("正解") {
                    let pagesObserver: TestableObserver<[WikipediaPage]>
                    let resultDescriptionObserver: TestableObserver<String>

                    let searchText = scheduler.createHotObservable(inputTextObservable)
                    let viewModel: SearchViewModel = SearchViewModel(
                        dependency: .init(
                            wikipediaAPI: wikipediaSearchRepositoryStub,
                            scheduler: scheduler
                        )
                    )

                    let input = SearchViewModel.Input(searchText: searchText.asObservable())
                    let output = viewModel.transform(input: input)

                    pagesObserver = scheduler.createObserver([WikipediaPage].self)
                    output.wikipediaPages
                        .bind(to: pagesObserver)
                        .disposed(by: self.disposeBag)

                    resultDescriptionObserver = scheduler.createObserver(String.self)
                    output.searchDescription
                        .bind(to: resultDescriptionObserver)
                        .disposed(by: self.disposeBag)

                    scheduler.start()

                    expect(pagesObserver.events).to(equal([
                        Recorded.next(5, [mockPage1, mockPage2]),
                        Recorded.next(9, [mockPage1, mockPage2])
                    ]))

                    expect(resultDescriptionObserver.events).to(equal([
                        Recorded.next(5, "Ryu 2件"),
                        Recorded.next(9, "Ryu1 2件")
                    ]))
                }
            }
        }
    }


}

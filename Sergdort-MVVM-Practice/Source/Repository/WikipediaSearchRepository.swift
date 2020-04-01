//
//  WikipediaAPI.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/03/19.
//

import RxSwift
import RxCocoa
import Foundation

public protocol WikipediaSearchProtocol: AnyObject {
    func search(from word: String) -> Single<[WikipediaPage]>
}

public class WikipediaSearchRepository: WikipediaSearchProtocol {
    private let host = URL(string: "https://ja.wikipedia.org")!
    private let path = "/w/api.php"
    private let urlSession: URLSession
    private let decoder: JSONDecoder = JSONDecoder()

    public init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    public func search(from word: String) -> Single<[WikipediaPage]> {
        var components = URLComponents(url: host, resolvingAgainstBaseURL: false)!
        components.path = path

        let items = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "list", value: "search"),
            URLQueryItem(name: "srsearch", value: word)
        ]

        components.queryItems = items

        return Single<[WikipediaPage]>.create { [weak self] single in
            let task = self?.urlSession.dataTask(with: components.url!) { data, _, error -> Void in
                do {
                    if let data = data,
                        let result = try self?.decoder.decode(WikipediaSearchResponse.self, from: data) {
                        single(.success(result.query.search))
                    }
                }
                catch {
                    single(.error(error))
                }
            }
            task?.resume()

            return Disposables.create { task?.cancel() }
        }
    }
}

//
//  WikipediaAPI.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/03/19.
//

import RxSwift
import RxCocoa

public protocol WikipediaAPI {
    func search(from word: String) -> Observable<[WikipediaPage]>
}

public class WikipediaDefaultAPI : WikipediaAPI {

    private let host = URL(string: "https://ja.wikipedia.org")!
    private let path = "/w/api.php"
    private let URLSession: Foundation.URLSession

    public init(URLSession: Foundation.URLSession) {
        self.URLSession = URLSession
    }

    public func search(from word: String) -> Observable<[WikipediaPage]> {

        var components = URLComponents(url: host, resolvingAgainstBaseURL: false)!
        components.path = path

        let items = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "list", value: "search"),
            URLQueryItem(name: "srsearch", value: word)
        ]

        components.queryItems = items

        let request = URLRequest(url: components.url!)
        return URLSession.rx.response(request: request)
            .map { pair in
                do {
                    let response = try JSONDecoder().decode(WikipediaSearchResponse.self,
                                                            from: pair.data)

                    return response.query.search
                } catch {
                    throw error
                }
        }
    }
}

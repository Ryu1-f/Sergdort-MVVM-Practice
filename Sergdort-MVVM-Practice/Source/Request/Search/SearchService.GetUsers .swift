//
//  SearchService.GetUser.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/04.
//

import Foundation
import APIKit

extension SearchService {
    /// ユーザーを検索する
    public struct GetUsers: Request {
        public typealias Response = Users
        public let parameters: Any?

        public var baseURL: URL {
            URL(string: "https://api.github.com")!
        }

        public var method: HTTPMethod {
            .get
        }

        public var path: String {
            basePath + "/users"
        }

        public init(with name: String) {
            self.parameters = ["q": name]
        }
    }
}

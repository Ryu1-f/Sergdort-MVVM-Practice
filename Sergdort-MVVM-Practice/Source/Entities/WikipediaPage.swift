//
//  WikipediaPage.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/03/21.
//

import Foundation

public struct WikipediaSearchResponse: Decodable {
    public let query: Query

    public struct Query: Decodable {
        public let search: [WikipediaPage]
    }
}

public struct WikipediaPage {
    public let id: String
    public let title: String
    public let url: URL
}

extension WikipediaPage: Equatable {
    public static func == (lhs: WikipediaPage, rhs: WikipediaPage) -> Bool {
        return lhs.id == rhs.id
    }
}

extension WikipediaPage: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "pageid"
        case title
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = String(try container.decode(Int.self, forKey: .id))

        self.title = try container.decode(String.self, forKey: .title)
        // 2.
        self.url = URL(string: "https://ja.wikipedia.org/w/index.php?curid=\(id)")!
    }
}

//
//  Users.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/05.
//

import Foundation
import RxDataSources

public struct Users: Codable {
    let total_count: Int
    public var items: [Item]
//    typealias Item = UserItem

    public struct UserItem: Codable {
        let login: String
        let avatar_url: String
    }
}

extension Users: SectionModelType {
    public typealias Item = UserItem

    public init(original: Users, items: [Item]) {
        self = original
        self.items = items
  }
}

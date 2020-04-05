//
//  Users.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/05.
//

import Foundation

public struct Users: Codable {
    let total_count: Int
    let items: [Item]

    struct Item: Codable {
        let login: String
        let avatar_url: String
    }
}

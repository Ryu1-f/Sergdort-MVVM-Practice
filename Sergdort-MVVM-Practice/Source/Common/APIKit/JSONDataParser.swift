//
//  JSONDataParser.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/05.
//

//import Foundation
import APIKit

public class JSONDataParser: APIKit.DataParser {
    public var contentType: String? {
        return "application/json"
    }

    public func parse(data: Data) throws -> Any {
        return data
    }
}

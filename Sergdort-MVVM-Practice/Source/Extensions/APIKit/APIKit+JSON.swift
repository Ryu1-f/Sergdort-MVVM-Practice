//
//  APIKit+JSON.swift
//  Sergdort-MVVM-Practice
//
//  Created by 深見龍一 on 2020/04/05.
//

import APIKit

extension APIKit.Request where Response: Decodable {
    public var dataParser: DataParser {
        return JSONDataParser()
    }

    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

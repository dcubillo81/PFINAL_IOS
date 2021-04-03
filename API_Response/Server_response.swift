//
//  Server_response.swift
//  Proyecto_final
//
//  Created by Daniel Cubillo on 8/3/21.
//

import Foundation

// Respuesta API usuarios random: - https://randomapi.com/api/6de6abfedb24f889e0b5f675edc50deb?fmt=raw&sole
struct RandomUser: Decodable {
    let first, last, email, address: String
    let created, balance: String
}


// respuesta quotes -
// MARK: - Welcome
struct Quotesresponse: Decodable {
    let success: Success
    let contents: Contents
    let baseurl: String
    let copyright: Copyright
}

// MARK: - Contents
struct Contents:Decodable {
    let quotes: [Quote]
}

// MARK: - Quote
struct Quote: Decodable {
    let quote, length, author: String
    let tags: [String]
    let category, language, date: String
    let permalink: String
    let id: String
    let background: String
    let title: String
}

// MARK: - Copyright
struct Copyright:Decodable {
    let year: Int
    let url: String
}

// MARK: - Success
struct Success:Decodable {
    let total: Int
}


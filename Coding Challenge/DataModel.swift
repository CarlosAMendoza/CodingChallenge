//
//  DataModel.swift
//  Coding Challenge
//
//  Created by Carlos Mendoza on 8/23/19.
//  Copyright © 2019 Carlos Mendoza. All rights reserved.
//

import Foundation

struct Feed: Codable {
    let title: String
    let results: [Result]
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case results = "results"
    }
}

struct Result: Codable {
    let artistName: String
    let id: String
    let releaseDate: String
    let name: String
    let kind: String
    let copyright: String
    let artistID: String
    let artistURL: String
    let artworkUrl100: String
    let url: String
    let contentAdvisoryRating: String?
    
    enum CodingKeys: String, CodingKey {
        case artistName = "artistName"
        case id = "id"
        case releaseDate = "releaseDate"
        case name = "name"
        case kind = "kind"
        case copyright = "copyright"
        case artistID = "artistId"
        case artistURL = "artistUrl"
        case artworkUrl100 = "artworkUrl100"
        case url = "url"
        case contentAdvisoryRating = "contentAdvisoryRating"
    }
}

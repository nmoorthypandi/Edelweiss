//
//  MoviesDataModel.swift
//  Edelweiss
//
//  Created by Aadithya on 27/01/22.
//

import Foundation
import UIKit

// MARK: - MoviesDataModel
struct MoviesDataModel: Codable {
    let status, copyright: String
    let hasMore: Bool
    let numResults: Int
    let results: [Movies]

    enum CodingKeys: String, CodingKey {
        case status, copyright
        case hasMore = "has_more"
        case numResults = "num_results"
        case results
    }
}

// MARK: - Result
struct Movies: Codable {
    let displayTitle, mpaaRating: String
    let criticsPick: Int
    let byline, headline, summaryShort, publicationDate: String
    let openingDate: String?
    let dateUpdated: String
    let link: Link
    var multimedia: Multimedia?

    enum CodingKeys: String, CodingKey {
        case displayTitle = "display_title"
        case mpaaRating = "mpaa_rating"
        case criticsPick = "critics_pick"
        case byline, headline
        case summaryShort = "summary_short"
        case publicationDate = "publication_date"
        case openingDate = "opening_date"
        case dateUpdated = "date_updated"
        case link, multimedia
    }
}

// MARK: - Link
struct Link: Codable {
    let type: String
    let url: String
    let suggestedLinkText: String

    enum CodingKeys: String, CodingKey {
        case type, url
        case suggestedLinkText = "suggested_link_text"
    }
}

// MARK: - Multimedia
struct Multimedia: Codable {
    let type: String
    let src: String
    let height, width: Int
    var image: Data?
}

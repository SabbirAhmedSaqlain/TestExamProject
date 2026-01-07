//
//  Article.swift
//  TestExam
//
//  Created by Sabbir on 1/6/26.
//

import Foundation

struct Article: Decodable {
    struct Source: Decodable {
        let id: String?
        let name: String?
    }

    let source: Source?
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
        case content
    }
}

extension Article {
    var displayAuthor: String { author?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? author! : "Unknown" }

    var formattedDate: String? {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iso.date(from: publishedAt) ?? ISO8601DateFormatter().date(from: publishedAt) {
            let df = DateFormatter()
            df.dateStyle = .medium
            df.timeStyle = .short
            return df.string(from: date)
        }
        return nil
    }
}

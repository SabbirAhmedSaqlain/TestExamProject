//
//  ViewController.swift
//  TestExam
//
//  Created by Sabbir on 1/6/26.
//

import RxSwift
import Foundation

final class NewsRepositoryImpl: NewsRepository {

    private let service = NewsAPIService()

    func fetchNews() -> Single<[Article]> {
        let query = "apple"
        let urlString =
        "\(AppEnvironment.current.baseURL)\(APIConstants.everything)?q=\(query)&sortBy=publishedAt&apiKey=\(AppEnvironment.current.apiKey)"

        guard let url = URL(string: urlString) else {
            return .error(NetworkError.invalidURL)
        }

        return service
            .request(url: url)
            .map { (response: NewsResponse) in response.articles }
    }
}

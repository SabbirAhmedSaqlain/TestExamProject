//
//  NewsAPIService.swift
//  TestExam
//
//  Created by Sabbir on 1/6/26.
//

import Foundation
import RxSwift

final class NewsAPIService: NetworkService {

    func request<T: Decodable>(url: URL) -> Single<T> {
        Single.create { single in
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    single(.failure(error))
                    return
                }

                guard let data = data else {
                    single(.failure(NetworkError.serverError("No data")))
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    single(.success(decoded))
                } catch {
                    single(.failure(NetworkError.decodingError))
                }
            }

            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}

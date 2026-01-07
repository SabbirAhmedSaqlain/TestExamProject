//
//  NewsRepository.swift
//  TestExam
//
//  Created by Sabbir on 1/6/26.
//

import RxSwift

protocol NewsRepository {
    func fetchNews() -> Single<[Article]>
}

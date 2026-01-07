//
//  NewsListViewModel.swift
//  TestExam
//
//  Created by Sabbir on 1/6/26.
//

import RxSwift
import RxCocoa
import Foundation

final class NewsListViewModel {

    private let repository: NewsRepository
    private let disposeBag = DisposeBag()

    let articles = BehaviorRelay<[Article]>(value: [])
    let error = PublishRelay<String>()

    init(repository: NewsRepository) {
        self.repository = repository
    }

    func loadNews() {
        repository.fetchNews()
            .subscribe(
                onSuccess: { [weak self] in self?.articles.accept($0) },
                onFailure: { [weak self] in self?.error.accept($0.localizedDescription) }
            )
            .disposed(by: disposeBag)
    }
}

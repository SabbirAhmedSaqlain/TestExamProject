//
//  NewsListViewController.swift
//  TestExam
//
//  Created by Sabbir on 1/6/26.
//

import UIKit
import RxSwift
import RxCocoa

final class NewsListViewController: UIViewController {

    private let tableView = UITableView()
    private let viewModel: NewsListViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: NewsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        setupTable()
        bind()
        viewModel.loadNews()
    }

    private func setupTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func bind() {
        viewModel.articles
            .bind(to: tableView.rx.items(
                cellIdentifier: "cell",
                cellType: NewsTableViewCell.self
            )) { _, article, cell in
                cell.configure(article)
            }
            .disposed(by: disposeBag)
    }
}

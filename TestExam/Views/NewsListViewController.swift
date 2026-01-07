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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension

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
        
        // Handle selection to show details
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Article.self))
            .subscribe(onNext: { [weak self] indexPath, article in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                // Initialize your detail view controller with the selected article
                let detailVC = NewsDetailViewController(article: article)
                self.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}


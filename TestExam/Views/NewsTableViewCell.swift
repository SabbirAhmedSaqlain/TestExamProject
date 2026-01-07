//
//  NewsTableViewCell.swift
//  TestExam
//
//  Created by Sabbir on 1/6/26.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {

    private let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        titleLabel.frame = contentView.bounds
        titleLabel.numberOfLines = 0
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(_ article: Article) {
        titleLabel.text = article.title
    }
}

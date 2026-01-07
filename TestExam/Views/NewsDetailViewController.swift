//
//  NewsDetailViewController.swift
//  TestExam
//
//  Created by Sabbir on 1/6/26.
//

import UIKit

final class NewsDetailViewController: UIViewController {

    private let article: Article

    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let imageView = UIImageView()
    private static let imageCache = NSCache<NSURL, UIImage>()

    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Details"
        setupViews()
        configure(with: article)
    }

    private func setupViews() {
        // Scroll view
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Content stack
        contentView.axis = .vertical
        contentView.spacing = 12
        contentView.alignment = .fill
        contentView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        contentView.isLayoutMarginsRelativeArrangement = true

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])

        // Image view
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.isHidden = true // Hidden by default; will show when an image loads
        contentView.addArrangedSubview(imageView)

        // Constrain image height (maintain a reasonable header size)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageHeight = imageView.heightAnchor.constraint(equalToConstant: 200)
        imageHeight.priority = .required
        imageHeight.isActive = true

        // Title label
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.numberOfLines = 0

        // Description label
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .secondaryLabel

        contentView.addArrangedSubview(titleLabel)
        contentView.addArrangedSubview(descriptionLabel)
    }

    private func configure(with article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description ?? ""

        // Reset image state
        imageView.image = nil
        imageView.isHidden = true

        // Attempt to load image from urlToImage if available
        if let urlString = article.urlToImage, let url = URL(string: urlString) {
            // Use cached image if present
            if let cached = NewsDetailViewController.imageCache.object(forKey: url as NSURL) {
                self.imageView.image = cached
                self.imageView.isHidden = false
                return
            }

            // Fetch image asynchronously
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else { return }
                guard error == nil, let data = data, let image = UIImage(data: data) else {
                    return
                }
                // Cache and display on main thread
                NewsDetailViewController.imageCache.setObject(image, forKey: url as NSURL)
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.imageView.isHidden = false
                }
            }
            task.resume()
        }
    }
}

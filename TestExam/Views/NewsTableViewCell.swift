//
//  NewsTableViewCell.swift
//  TestExam
//
//  Created by Sabbir on 1/6/26.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {

    // MARK: - Subviews
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .secondarySystemBackground
        v.layer.cornerRadius = 12
        v.layer.masksToBounds = true
        return v
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 3
        l.font = .preferredFont(forTextStyle: .headline)
        l.adjustsFontForContentSizeCategory = true
        l.textColor = .label
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 2
        l.font = .preferredFont(forTextStyle: .subheadline)
        l.adjustsFontForContentSizeCategory = true
        l.textColor = .secondaryLabel
        return l
    }()

    private let thumbnailView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = UIColor.secondarySystemFill
        return iv
    }()

    private var imageTask: URLSessionDataTask?

    // Simple shared cache for images
    private static let imageCache = NSCache<NSURL, UIImage>()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
        configureSelection()
        accessoryType = .disclosureIndicator
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Setup
    private func setupViews() {
        let cream = UIColor(red: 1.0, green: 0.98, blue: 0.94, alpha: 1.0)
        backgroundColor = cream
        contentView.backgroundColor = cream
        contentView.addSubview(containerView)

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.axis = .vertical
        textStack.spacing = 6

        let hStack = UIStackView(arrangedSubviews: [textStack, thumbnailView])
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.alignment = .top
        hStack.spacing = 12

        containerView.addSubview(hStack)

        // Constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            hStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            hStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            hStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            hStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),

            thumbnailView.widthAnchor.constraint(equalToConstant: 72),
            thumbnailView.heightAnchor.constraint(equalToConstant: 72)
        ])
    }

    private func setupLayout() { /* Layout handled in setupViews() for clarity */ }

    private func configureSelection() {
        let bg = UIView()
        bg.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(0.6)
        selectedBackgroundView = bg
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        thumbnailView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }

    // MARK: - Configure
    func configure(_ article: Article) {
        titleLabel.text = article.title

        let sourceName = article.source?.name?.trimmingCharacters(in: .whitespacesAndNewlines)
        let dateText = article.formattedDate
        if let name = sourceName, !name.isEmpty, let dateText = dateText {
            subtitleLabel.text = "\(name) • \(dateText)"
        } else if let name = sourceName, !name.isEmpty {
            subtitleLabel.text = name
        } else if let dateText = dateText {
            subtitleLabel.text = dateText
        } else {
            subtitleLabel.text = article.description
        }

        // Load image if available
        if let urlString = article.urlToImage, let url = URL(string: urlString) {
            loadImage(from: url)
        } else {
            thumbnailView.image = nil
        }
    }

    // MARK: - Image Loading
    private func loadImage(from url: URL) {
        let nsURL = url as NSURL
        if let cached = NewsTableViewCell.imageCache.object(forKey: nsURL) {
            thumbnailView.image = cached
            return
        }

        // Placeholder state
        thumbnailView.image = nil

        imageTask?.cancel()
        imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, let image = UIImage(data: data), error == nil else { return }
            NewsTableViewCell.imageCache.setObject(image, forKey: nsURL)
            DispatchQueue.main.async {
                // Ensure the cell hasn't been reused for another image
                self.thumbnailView.image = image
            }
        }
        imageTask?.resume()
    }
}


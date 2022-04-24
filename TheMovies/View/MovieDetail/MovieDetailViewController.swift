//
//  MovieDetailViewController.swift
//  TheMovies
//
//  Created by Sayali Deopurkar on 23/04/22.
//

import UIKit

class MovieDetailViewController: UIViewController {
    private var viewModel: MovieDetailViewModel
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .cGrayDark
        return label
    }()
    
    private lazy var itemImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    private lazy var descriptionTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = .cGrayDark
        return label
    }()
    private lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .cGray
        return label
    }()
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()
    private let primaryDataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.axis = .vertical
        return stackView
    }()
    private let descriptionDataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.axis = .vertical
        return stackView
    }()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

}

extension MovieDetailViewController {
    private func setupViews() {
        self.title = "Details"
        view.backgroundColor = .cBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mainStackView)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.cTheme]
        
        [titleLabel
        ].forEach { primaryDataStackView.addArrangedSubview($0) }
        
        [descriptionTitleLabel,
         descriptionLabel].forEach { descriptionDataStackView.addArrangedSubview($0) }
        [itemImageView,
         primaryDataStackView,
         separatorView,
         descriptionDataStackView].forEach { mainStackView.addArrangedSubview($0) }
        
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        let placeholderImage = "placeholderIcon"
        if let urlPath = viewModel.posterPath {
            Task {
                let imageData = try await viewModel.imageService.load(urlPath: urlPath)
                DispatchQueue.main.async {
                    if let image = UIImage(data: imageData) {
                        self.itemImageView.image = image
                    } else {
                        self.itemImageView.image = UIImage(named: placeholderImage)
                    }
                }
            }
        } else {
            //show placeholder image
            itemImageView.image = UIImage(named: placeholderImage)
        }
        
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0),
            mainStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0),
            mainStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            scrollView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.0),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            itemImageView.heightAnchor.constraint(equalToConstant: 200.0)
        ])
    }
}

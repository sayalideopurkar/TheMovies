//
//  ListTableViewCell.swift
//  TheMovies
//
//  Created by Sayali Deopurkar on 20/04/22.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    static let cellID = "ListTableViewCell"

    private lazy var itemImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .cGrayLightest
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .cGrayDark
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .cGrayDark
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.axis = .horizontal
        //stackView.clipsToBounds = true
        //stackView.layer.cornerRadius = 15
        stackView.backgroundColor = .white
        return stackView
    }()
    private let dataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        stackView.alignment = .top
        stackView.axis = .vertical
        return stackView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        initViews()
    }
    
    func initViews() {
        backgroundColor = .clear
        contentView.addSubview(mainStackView)
        configureConstraints()
        
        [titleLabel,
         yearLabel].forEach { dataStackView.addArrangedSubview($0) }
        [itemImageView,
         dataStackView].forEach { mainStackView.addArrangedSubview($0) }
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            mainStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            mainStackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            itemImageView.heightAnchor.constraint(equalToConstant: 120.0),
            itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor, multiplier: 1)
        ])
    }
    
    //MARK: - Cell setup
    /**
     Setup cell using model
     */
    func configure(with model: Result, imageService: ImageService) {
        let placeholderImage = "placeholderIcon"        
        if let imagePath = model.posterPath {
            do {
                Task {
                    let imageData = try await imageService.load(urlPath: imagePath)
                    DispatchQueue.main.async {
                        if let image = UIImage(data: imageData) {
                            self.itemImageView.image = image
                        } else {
                            self.itemImageView.image = UIImage(named: placeholderImage)
                        }
                    }
                }
            }
        } else {
            //add placeholder
            itemImageView.image = UIImage(named: placeholderImage)
        }
        titleLabel.text = model.title
        yearLabel.text = model.releaseDate
    }


}

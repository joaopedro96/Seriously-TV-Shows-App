//
//  FavoritesTableViewCell.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 09/11/21.
//

import UIKit

protocol FavoritesTableViewCellProtocol: AnyObject {
    func didTapCell(with id: String)
}

class FavoritesTableViewCell: UITableViewCell {
    
    // MARK: - CONSTANTS
    
    private struct Constants {
        static let titleLabelText = "Title"
        static let productorLabelText = "Maker"
    }
    
    private enum Metrics {
        static let cornerRadius: CGFloat = 8
        static let mediumSpacing: CGFloat = 12
        static let fontSizeSmall: CGFloat = 14
        static let shortMargin: CGFloat = 12
        static let roundMargin: CGFloat = 20
        static let buttonSize: CGSize = CGSize(width: 50, height: 50)
        static let posterViewWidth: CGFloat = 70
    }
    
    // MARK: - PROPERTIES
    
    weak var delegate: FavoritesTableViewCellProtocol?
    private var buttonState: Bool = false
    private var favoriteCellData: FavoritesViewDataModel?
    
    // MARK: - INITIALIZER
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var posterView: UIImageView = {
        let setupComponent = UIImageView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.backgroundColor = .lightGray
        setupComponent.layer.cornerRadius = Metrics.cornerRadius
        setupComponent.contentMode = .scaleToFill
        setupComponent.clipsToBounds = true
        setupComponent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBanner)))
        setupComponent.isUserInteractionEnabled = true
        setupComponent.widthAnchor.constraint(equalToConstant: Metrics.posterViewWidth).isActive = true
        return setupComponent
    }()
    
    private lazy var stackView: UIStackView = {
        let setupComponent = UIStackView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.axis = .vertical
        setupComponent.distribution = .fill
        setupComponent.spacing = Metrics.mediumSpacing
        return setupComponent
    }()
    
    private lazy var titleLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.text = Constants.titleLabelText
        setupComponent.numberOfLines = 1
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeSmall, weight: .bold)
        setupComponent.textColor = .white
        return setupComponent
    }()
    
    private lazy var productorLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.text = Constants.productorLabelText
        setupComponent.numberOfLines = 1
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeSmall, weight: .regular)
        setupComponent.textColor = .gray300
        return setupComponent
    }()
    
    private lazy var likeButton: UIButton = {
        let setupComponent = UIButton(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        setupComponent.heightAnchor.constraint(equalToConstant: Metrics.buttonSize.height).isActive = true
        setupComponent.widthAnchor.constraint(equalToConstant: Metrics.buttonSize.width).isActive = true
        setupComponent.setImage(.uncheckedHeartIcon, for: .selected)
        setupComponent.setImage(.checkedHeartIcon, for: .normal)
        return setupComponent
    }()
    
    // MARK: - PUBLIC METHODS
    
    public func updateFavoritesCellView(with favoriteData: FavoritesViewDataModel) {
        favoriteCellData = favoriteData
        posterView.image = favoriteData.banner
        titleLabel.text = favoriteData.title
        productorLabel.text = favoriteData.network
    }
    
    // MARK: - PRIVATE METHODS
    
    @objc private func didTapBanner() {
        guard let cellData = favoriteCellData else { return }
        let stringId = String(cellData.id)
        delegate?.didTapCell(with: stringId)
    }
    
    @objc private func didTapLikeButton() {
        buttonState = !buttonState
        likeButton.isSelected = buttonState
    }

    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
        customizeView()
    }
    
    private func buildViewHierarchy() {
        contentView.addSubview(posterView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(productorLabel)
        contentView.addSubview(likeButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metrics.shortMargin),
            posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.shortMargin),
            posterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Metrics.shortMargin),
            
            stackView.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: Metrics.roundMargin),
            stackView.centerYAnchor.constraint(equalTo: posterView.centerYAnchor),
            
            likeButton.centerYAnchor.constraint(equalTo: posterView.centerYAnchor),
            likeButton.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: Metrics.roundMargin),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.roundMargin)
        ])
    }
    
    private func customizeView() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .indigo600
        contentView.layer.cornerRadius = Metrics.cornerRadius
    }
}

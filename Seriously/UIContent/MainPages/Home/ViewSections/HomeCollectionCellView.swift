//
//  HomeCollectionCellView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 01/11/21.
//

import UIKit

protocol HomeCollectionCellViewProtocol: AnyObject {
    func goToCollectionView(with favoritesData: FavoritesViewDataModel)
    func didTapCellPoster(with title: String)
    func updateCellPosterView(with urlImage: String) -> UIImage?
}

class HomeCollectionCellView: UICollectionViewCell {
    
    // MARK: - CONSTANTS
    
    private enum Metrics {
        static let posterViewCornerRadius: CGFloat = 8
        static let fontSizeSmall: CGFloat = 14
        static let tinyMargin: CGFloat = 4
        static let smallMargin: CGFloat = 8
        static let mediumMargin: CGFloat = 14
        static let likeButtonSize: CGSize = CGSize(width: 30, height: 30)
    }
    
    // MARK: - PROPERTIES
    
    weak var delegate: HomeCollectionCellViewProtocol?
    private var buttonState: Bool = false
    private var tvShowData: TvShowPlanData?
    
    // MARK: - INITIALIZER
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var posterView: UIImageView = {
        let setupComponent = UIImageView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.layer.cornerRadius = Metrics.posterViewCornerRadius
        setupComponent.contentMode = .scaleToFill
        setupComponent.backgroundColor = .lightGray
        setupComponent.clipsToBounds = true
        setupComponent.isUserInteractionEnabled = true
        setupComponent.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        setupComponent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPoster)))
        return setupComponent
    }()
    
    private lazy var titleLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.numberOfLines = 1
        setupComponent.textColor = .white
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeSmall, weight: .bold)
        return setupComponent
    }()
    
    private lazy var productorLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.numberOfLines = 1
        setupComponent.textColor = .gray300
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeSmall, weight: .regular)
        setupComponent.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return setupComponent
    }()
    
    private lazy var likeButton: UIButton = {
        let setupComponent = UIButton(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.setImage(.uncheckedHeartIcon, for: .normal)
        setupComponent.setImage(.checkedHeartIcon, for: .selected)
        setupComponent.heightAnchor.constraint(equalToConstant: Metrics.likeButtonSize.height).isActive = true
        setupComponent.widthAnchor.constraint(equalToConstant: Metrics.likeButtonSize.width).isActive = true
        setupComponent.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return setupComponent
    }()
    
    // MARK: - PUBLIC METHODS
    
    public func updateCollectionCell(with tvShowData: TvShowPlanData) {
        posterView.image = nil
        self.tvShowData = tvShowData
        titleLabel.text = tvShowData.name
        productorLabel.text = tvShowData.network
        updateCellPosterView(with: tvShowData.image)
    }
    
    // MARK: - PRIVATE METHODS
    
    private func updateCellPosterView(with urlString: String) {
        DispatchQueue.global().async {
            guard let loadedImage = self.delegate?.updateCellPosterView(with: urlString) else { return }
            DispatchQueue.main.async {
                self.posterView.image = loadedImage
            }
        }
    }
        
    @objc private func didTapPoster() {
        guard let tvShowData = tvShowData else { return }
        delegate?.didTapCellPoster(with: tvShowData.searchLink)
    }
    
    @objc private func didTapLikeButton() {
        buttonState = !buttonState
        likeButton.isSelected = buttonState
        if buttonState {
            guard let tvShowData = tvShowData else { return }
            let favoriteShowData = FavoritesViewDataModel(title: tvShowData.name,
                                                          network: tvShowData.network,
                                                          banner: posterView.image,
                                                          id: tvShowData.id)
            delegate?.goToCollectionView(with: favoriteShowData)
        }
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
    }
    
    private func buildViewHierarchy() {
        contentView.addSubview(posterView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(productorLabel)
        contentView.addSubview(likeButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: Metrics.mediumMargin),
            titleLabel.leadingAnchor.constraint(equalTo: posterView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: posterView.trailingAnchor),
            
            productorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.tinyMargin),
            productorLabel.leadingAnchor.constraint(equalTo: posterView.leadingAnchor),
            productorLabel.trailingAnchor.constraint(equalTo: posterView.trailingAnchor),
            productorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            likeButton.centerYAnchor.constraint(equalTo: posterView.bottomAnchor),
            likeButton.trailingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: -Metrics.smallMargin)
        ])
    }
}

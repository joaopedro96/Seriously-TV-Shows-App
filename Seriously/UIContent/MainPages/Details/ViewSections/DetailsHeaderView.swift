//
//  DetailsHeaderView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 19/11/21.
//

import UIKit

protocol DetailsHeaderViewProtocol: AnyObject {
    func goToDetailsView(with favoritesData: FavoritesViewDataModel)
}

class DetailsHeaderView: UIView {
    
    // MARK: - CONSTANTS
    
    private struct Constants {
        static let arcanePosterURL = "https://static.episodate.com/images/tv-show/full/73463.jpg"
    }
    
    private enum Metrics {
        static let posterViewAlpha: CGFloat = 0.8
        static let tinySpacing: CGFloat = 2
        static let tinyMargin: CGFloat = 4
        static let shortMargin: CGFloat = 12
        static let titleLabelMargin: CGFloat = 120
        static let margin: CGFloat = 16
        static let standardMargin: CGFloat = 24
        static let fontSizeBig: CGFloat = 20
        static let screenWidth = UIScreen.main.bounds.width
        static let posterImageRelativeHeight = 1.4 * screenWidth
        static let rateImageRelativeHeight = 0.05 * screenWidth
        static let likeButtonSize: CGSize = CGSize(width: 60, height: 60)
        static let gradientEffectSize: CGRect = CGRect(x: 0, y: 0, width: screenWidth, height: posterImageRelativeHeight)
    }
    
    // MARK: - PROPERTIES
    
    private var tvShowRate: Double = 0
    private var buttonState: Bool = false
    private var detailsPlanData: TvShowDetailsPlanData?
    weak var delegate: DetailsHeaderViewProtocol?
    
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
        setupComponent.backgroundColor = .gray300
        setupComponent.alpha = Metrics.posterViewAlpha
        setupComponent.contentMode = .scaleToFill
        setupComponent.clipsToBounds = true
        setupComponent.isUserInteractionEnabled = true
        return setupComponent
    }()
    
    private lazy var posterViewGradientEffect: UIView = {
        let setupComponent = UIView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        let gradient = CAGradientLayer()
        gradient.frame = Metrics.gradientEffectSize
        gradient.colors = [UIColor.clear.cgColor, UIColor.indigo500.cgColor]
        gradient.locations = [0.5, 1.0]
        setupComponent.layer.insertSublayer(gradient, at: 0)
        return setupComponent
    }()
    
    private lazy var titleLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.numberOfLines = 1
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeBig, weight: .bold)
        setupComponent.textColor = .white
        setupComponent.textAlignment = .center
        return setupComponent
    }()
    
    private lazy var starStackView: UIStackView = {
        let setupComponent = UIStackView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.axis = .horizontal
        setupComponent.spacing = Metrics.tinySpacing
        setupComponent.distribution = .fillEqually
        return setupComponent
    }()
    
    private lazy var likeButton: UIButton = {
        let setupComponent = UIButton(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.setImage(.uncheckedHeartIcon, for: .normal)
        setupComponent.setImage(.checkedHeartIcon, for: .selected)
        setupComponent.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        setupComponent.heightAnchor.constraint(equalToConstant: Metrics.likeButtonSize.height).isActive = true
        setupComponent.widthAnchor.constraint(equalToConstant: Metrics.likeButtonSize.width).isActive = true
        return setupComponent
    }()
    
    // MARK: - PUBLIC METHODS
    
    public func updateHeaderView(with entity: TvShowDetailsPlanData) {
        self.detailsPlanData = entity
        titleLabel.text = entity.title
        tvShowRate = Double(entity.rate) ?? 0.0
        updateStars(with: tvShowRate)
        updateCellPosterView(with: entity.poster)
    }
    
    // MARK: - PRIVATE METHODS
    
    @objc private func didTapLikeButton() {
        buttonState = !buttonState
        likeButton.isSelected = buttonState
        if buttonState {
            guard let detailsPlanData = detailsPlanData else { return }
            let favoriteShowData = FavoritesViewDataModel(title: detailsPlanData.title,
                                                          network: detailsPlanData.network,
                                                          banner: posterView.image,
                                                          id: detailsPlanData.id)
            delegate?.goToDetailsView(with: favoriteShowData)
        }
    }
    
    private func updateCellPosterView(with urlString: String) {
        if urlString == Constants.arcanePosterURL {
            self.posterView.image = .arcanePoster
        } else {
            guard let url = URL(string: urlString) else { return }
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                guard let loadedImage = data else { return }
                DispatchQueue.main.async {
                    if data != nil { self.posterView.image = UIImage(data: loadedImage) }
                }
            }
        }
    }
    
    private func updateStars(with rate: Double) {
        switch rate {
            case ..<1:
                addStarToStackView(with: false, and: 5)
                
            case 1..<3:
                starStackView.addArrangedSubview(DetailsStarRateView(starState: true))
                addStarToStackView(with: false, and: 4)
                
            case 3..<5:
                addStarToStackView(with: true, and: 2)
                addStarToStackView(with: false, and: 3)
                
            case 5..<8:
                addStarToStackView(with: true, and: 3)
                addStarToStackView(with: false, and: 2)
                
            case 8..<9.6:
                addStarToStackView(with: true, and: 4)
                starStackView.addArrangedSubview(DetailsStarRateView(starState: false))
                
            case 9.6...10:
                addStarToStackView(with: true, and: 5)
                
            default:
                addStarToStackView(with: false, and: 5)
        }
    }
    
    private func addStarToStackView(with state: Bool, and repeats: Int) {
        for _ in 1...repeats {
            starStackView.addArrangedSubview(DetailsStarRateView(starState: state))
        }
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
    }
    
    private func buildViewHierarchy() {
        addSubview(posterView)
        addSubview(titleLabel)
        addSubview(starStackView)
        posterView.addSubview(posterViewGradientEffect)
        addSubview(likeButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            posterView.topAnchor.constraint(equalTo: topAnchor),
            posterView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterView.heightAnchor.constraint(equalToConstant: Metrics.posterImageRelativeHeight),
            
            posterViewGradientEffect.topAnchor.constraint(equalTo: posterView.topAnchor),
            posterViewGradientEffect.leadingAnchor.constraint(equalTo: posterView.leadingAnchor),
            posterViewGradientEffect.trailingAnchor.constraint(equalTo: posterView.trailingAnchor),
            posterViewGradientEffect.bottomAnchor.constraint(equalTo: posterView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: Metrics.standardMargin),
            titleLabel.leadingAnchor.constraint(equalTo: posterView.leadingAnchor, constant: Metrics.tinyMargin),
            titleLabel.trailingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: -Metrics.tinyMargin),
            
            starStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.shortMargin),
            starStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: Metrics.titleLabelMargin),
            starStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -Metrics.titleLabelMargin),
            starStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.standardMargin),
            starStackView.heightAnchor.constraint(equalToConstant: Metrics.rateImageRelativeHeight),
            
            likeButton.bottomAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 16),
            likeButton.trailingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: -Metrics.standardMargin)
        ])
    }
}

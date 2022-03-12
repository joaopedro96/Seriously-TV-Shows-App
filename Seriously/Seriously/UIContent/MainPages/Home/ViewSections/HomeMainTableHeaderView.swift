//
//  HomeMainTableHeaderView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 01/11/21.
//

import UIKit

protocol HomeHeaderViewProtocol: AnyObject {
    func didTapHeaderBanner(with title: String)
}

class HomeMainTableHeaderView: UIView {
    
    // MARK: - CONSTANTS
    
    private struct Constants {
        static let bannerTitle = "arcane"
    }
    
    private enum Metrics {
        static let screenWidth = UIScreen.main.bounds.width
        static let bannerRelativeHeight: CGFloat = 0.5
        static let bannerCornerRadius: CGFloat = 16
        static let bannerButtonSize: CGSize = CGSize(width: 60, height: 60)
        static let margin: CGFloat = 16
        static let bigMargin: CGFloat = 32
    }
    
    // MARK: - PROPERTIES
    
    private var buttonState: Bool = false
    weak var delegate: HomeHeaderViewProtocol?
    
    // MARK: - INITIALIZER
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var highlightBannerView: UIImageView = {
        let setupComponent = UIImageView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.layer.cornerRadius = Metrics.bannerCornerRadius
        setupComponent.contentMode = .scaleAspectFill
        setupComponent.image = .arcaneBanner
        setupComponent.clipsToBounds = true
        setupComponent.isUserInteractionEnabled = true
        setupComponent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBanner)))
        return setupComponent
    }()
    
    private lazy var likeButton: UIButton = {
        let setupComponent = UIButton(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.setImage(.uncheckedHeartIcon, for: .normal)
        setupComponent.setImage(.checkedHeartIcon, for: .selected)
        setupComponent.isHidden = true
        setupComponent.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        setupComponent.heightAnchor.constraint(equalToConstant: Metrics.bannerButtonSize.height).isActive = true
        setupComponent.widthAnchor.constraint(equalToConstant: Metrics.bannerButtonSize.width).isActive = true
        return setupComponent
    }()
    
    // MARK: - PRIVATE METHODS
    
    @objc private func didTapBanner() {
        delegate?.didTapHeaderBanner(with: Constants.bannerTitle)
    }
    
    @objc private func didTapLikeButton() {
        buttonState = !buttonState
        likeButton.isSelected = buttonState
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
    }
    
    private func buildViewHierarchy() {
        addSubview(highlightBannerView)
        addSubview(likeButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            highlightBannerView.topAnchor.constraint(equalTo: topAnchor),
            highlightBannerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.margin),
            highlightBannerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.margin),
            highlightBannerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.bigMargin),
            highlightBannerView.heightAnchor.constraint(equalToConstant: Metrics.screenWidth * Metrics.bannerRelativeHeight),
            
            likeButton.centerYAnchor.constraint(equalTo: highlightBannerView.bottomAnchor),
            likeButton.trailingAnchor.constraint(equalTo: highlightBannerView.trailingAnchor, constant: -Metrics.bigMargin)
        ])
    }
}

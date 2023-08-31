//
//  DetailsView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 18/11/21.
//

import UIKit

class DetailsView: UIView {
    
    // MARK: - PROPERTIES
    
    weak var delegate: DetailsViewProtocol?
    
    // MARK: - INITIALIZER
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let setupComponent = UIScrollView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.contentInsetAdjustmentBehavior = .never
        setupComponent.bounces = false
        setupComponent.scrollsToTop = true
        setupComponent.showsVerticalScrollIndicator = false
        return setupComponent
    }()
    
    private lazy var containerStackView: UIStackView = {
        let setupComponent = UIStackView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.axis = .vertical
        setupComponent.distribution = .fill
        return setupComponent
    }()
    
    private var modalDraggerLineView: ModalDraggerLine = {
        let setupComponent = ModalDraggerLine(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        return setupComponent
    }()

    private lazy var headerView: DetailsHeaderView = {
        let setupComponent = DetailsHeaderView()
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.delegate = self
        setupComponent.isHidden = true
        return setupComponent
    }()
    
    private lazy var descriptionView: DetailsDescriptionView = {
        let setupComponent = DetailsDescriptionView()
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.isHidden = true
        return setupComponent
    }()
    
    private lazy var pictureView: DetailsPictureView = {
        let setupComponent = DetailsPictureView()
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.isHidden = true
        setupComponent.delegate = self
        return setupComponent
    }()
    
    private lazy var episodesView: DetailsEpisodeView = {
        let setupComponent = DetailsEpisodeView()
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.isHidden = true
        return setupComponent
    }()
    
    private lazy var skeletonView: UIView = {
        let setupComponent = DetailsSkeletonView()
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        return setupComponent
    }()
    
    // MARK: - PUBLIC METHODS
    
    public func updateDetailsView(with entity: TvShowDetailsPlanData) {
        DispatchQueue.main.async {
            self.headerView.updateHeaderView(with: entity)
            self.descriptionView.updateDescriptionView(with: entity)
            self.pictureView.updatePicturesView(with: entity.pictures)
            self.episodesView.updateEpisodesView(with: entity.episodes)
            self.disableSkeletonView()
        }
    }
    
    // MARK: - PRIVATE METHODS
    
    private func disableSkeletonView() {
        headerView.isHidden = false
        descriptionView.isHidden = false
        pictureView.isHidden = false
        episodesView.isHidden = false
        guard let skeletonIndex = self.containerStackView.subviews.firstIndex(of: self.skeletonView) else { return }
        self.containerStackView.arrangedSubviews[skeletonIndex].removeFromSuperview()
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
        customizeView()
    }
    
    private func buildViewHierarchy() {
        self.addSubview(scrollView)
        self.addSubview(modalDraggerLineView)
        scrollView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(skeletonView)
        containerStackView.addArrangedSubview(headerView)
        containerStackView.addArrangedSubview(descriptionView)
        containerStackView.addArrangedSubview(pictureView)
        containerStackView.addArrangedSubview(episodesView)
    }
    
    private func addConstraints() {
        let containerStackViewHeightConstraint = containerStackView.heightAnchor.constraint(equalTo: heightAnchor)
        containerStackViewHeightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            containerStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerStackView.widthAnchor.constraint(equalTo: widthAnchor),
            containerStackViewHeightConstraint,
            
            modalDraggerLineView.topAnchor.constraint(equalTo: containerStackView.topAnchor),
            modalDraggerLineView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
            modalDraggerLineView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor)
        ])
    }
    
    private func customizeView() {
        self.backgroundColor = .indigo500
    }
}

// MARK: - EXTENSIONS

extension DetailsView: DetailsHeaderViewProtocol {
    func goToDetailsView(with favoriteData: FavoritesViewDataModel) {
        delegate?.goToDetailsViewController(with: favoriteData)
    }
}

extension DetailsView: DetailsPictureViewProtocol {
    func loadImage(from urlString: String) -> UIImage? {
        delegate?.loadImage(from: urlString)
    }
}
